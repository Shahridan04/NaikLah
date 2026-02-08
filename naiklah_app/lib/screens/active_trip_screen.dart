import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart'; // For HapticFeedback
import 'dart:async';
import '../services/trip_simulation_service.dart';
import '../services/demo_route_data.dart';

class ActiveTripScreen extends StatefulWidget {
  final bool isWalking;
  const ActiveTripScreen({super.key, this.isWalking = false});

  @override
  State<ActiveTripScreen> createState() => _ActiveTripScreenState();
}

class _ActiveTripScreenState extends State<ActiveTripScreen>
    with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Brand Colors
  static const Color emeraldGreen = Color(0xFF10B981);
  static const Color hotPink = Color(0xFFEC4899);
  static const Color alertRed = Color(0xFFEF4444);

  // Animation State
  late AnimationController _markerController;
  late Animation<double> _animation;
  LatLng _currentMarkerPos = const LatLng(3.147271, 101.699533);
  LatLng _targetMarkerPos = const LatLng(3.147271, 101.699533);

  // SOS Pulse Animation
  late AnimationController _panicPulseController;
  late Animation<double> _panicPulseAnimation;

  bool _isPanicActive = false;
  bool _isFollowingUser = true; // State for Follow Mode
  String _lastStatus = 'active'; // Track status changes for effects

  @override
  void initState() {
    super.initState();
    // Initialize Marker Animation Controller
    _markerController = AnimationController(
      duration: const Duration(seconds: 1), // duration matches update interval
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _markerController,
      curve: Curves.linear,
    );

    // Initialize SOS Pulse Controller
    _panicPulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _panicPulseAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _panicPulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _markerController.dispose();
    _panicPulseController.dispose();
    super.dispose();
  }

  void _triggerPanic() async {
    setState(() => _isPanicActive = true);

    // 1. Haptic Feedback (Heavy Impact)
    HapticFeedback.heavyImpact();

    // 2. Start Pulse Animation
    _panicPulseController.repeat(reverse: true);

    // Update Simulation Service to prevent overwrite
    TripSimulationService().setEmergency(true);

    // Update Firestore to trigger alert on Mom's phone
    await _firestore.collection('trips').doc('demo_trip').update({
      'status': 'emergency',
      'lastUpdated': FieldValue.serverTimestamp(),
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('SOS SENT! NOTIFYING GUARDIAN! 🚨'),
          backgroundColor: alertRed,
          duration: Duration(seconds: 5),
        ),
      );
      // 4. Show Emergency Contacts Sheet
      if (mounted) {
        _showEmergencyContacts(context);
      }
    }
  }

  void _showEmergencyContacts(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'EMERGENCY ASSISTANCE',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 24),
            _buildEmergencyButton(
              label: 'Call Guardian (Mom)',
              subLabel: '+60 12-345 6789',
              icon: Icons.person_pin,
              color: hotPink,
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Calling Mom...')));
              },
            ),
            const SizedBox(height: 16),
            _buildEmergencyButton(
              label: 'Call Police (999)',
              subLabel: 'Emergency Services',
              icon: Icons.local_police,
              color: Colors.blue.shade800,
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Calling Police (999)...')),
                );
              },
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyButton({
    required String label,
    required String subLabel,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withValues(alpha: 0.1),
          foregroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: color.withValues(alpha: 0.5)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subLabel,
                  style: TextStyle(
                    fontSize: 12,
                    color: color.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _endTrip(String status) {
    // Stop simulation
    TripSimulationService().stopSimulation();

    // CRITICAL: Update Firestore so Guardian knows trip ended!
    if (status != 'ended') {
      _firestore.collection('trips').doc('demo_trip').update({
        'status': 'ended',
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    }

    if (status == 'emergency' || status == 'deviation' || status == 'alert') {
      // Provide haptic feedback for bad trip too? maybe not.
      Navigator.pop(context);
      return;
    }

    // SHOW TRIP SUMMARY DIALOG
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 1. Success Icon
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: emeraldGreen,
                  child: Icon(Icons.check, color: Colors.white, size: 40),
                ),
                const SizedBox(height: 16),
                // 2. Title
                const Text(
                  "Trip Completed!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                // 3. Body
                Text(
                  "You stayed on the safe route and arrived safely.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 24),
                // 4. Reward
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        "REWARD EARNED",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "+50 Points",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // 5. Action Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                      Navigator.pop(context); // Close screen
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: emeraldGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Return Home",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Calculate interpolated position
  LatLng _getAnimatedPosition(double value) {
    return LatLng(
      _currentMarkerPos.latitude +
          (_targetMarkerPos.latitude - _currentMarkerPos.latitude) * value,
      _currentMarkerPos.longitude +
          (_targetMarkerPos.longitude - _currentMarkerPos.longitude) * value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isWalking ? 'Walking Trip' : 'Trip to Pudu Sentral',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: _isPanicActive ? alertRed : emeraldGreen,
        leading:
            const SizedBox(), // Remove back button to force use of "End Trip"
        actions: [
          StreamBuilder<DocumentSnapshot>(
            stream: _firestore.collection('trips').doc('demo_trip').snapshots(),
            builder: (context, snapshot) {
              final status = snapshot.hasData && snapshot.data!.exists
                  ? (snapshot.data!.data() as Map<String, dynamic>)['status']
                            as String? ??
                        'active'
                  : 'active';

              return TextButton(
                onPressed: () => _endTrip(status),
                child: const Text(
                  'END TRIP',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: _isFollowingUser
          ? null
          : Padding(
              padding: const EdgeInsets.only(top: 80), // Avoid AppBar
              child: FloatingActionButton.extended(
                onPressed: () {
                  setState(() => _isFollowingUser = true);
                },
                backgroundColor: Colors.white,
                foregroundColor: emeraldGreen,
                elevation: 4,
                icon: const Icon(Icons.center_focus_strong),
                label: const Text("Re-center"),
              ),
            ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _firestore.collection('trips').doc('demo_trip').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.data!.exists) {
            return const Center(child: Text('Waiting for trip to start...'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          // Default to KL (Masjid Jamek) if no data
          final double lat = data['currentLocation']['latitude'] ?? 3.147271;
          final double lng = data['currentLocation']['longitude'] ?? 101.699533;
          final String status = data['status'] ?? 'unknown';
          final bool isOffRoute =
              status == 'alert' ||
              status == 'emergency' ||
              status == 'deviation';

          final LatLng newTarget = LatLng(lat, lng);

          // Update Animation Logic
          if (newTarget != _targetMarkerPos) {
            if (_markerController.isAnimating) {
              _currentMarkerPos = _getAnimatedPosition(_markerController.value);
            } else {
              _currentMarkerPos = _targetMarkerPos;
            }

            _targetMarkerPos = newTarget;
            _markerController.forward(from: 0.0);
          }

          // Re-trigger panic state if loaded from firestore (persistence)
          if (status == 'emergency' && !_isPanicActive) {
            // Sync local state if needed
          }

          // REACTIVE JUICE: Trigger Effects on Status Change
          if (status != _lastStatus) {
            final isbadNow =
                status == 'deviation' ||
                status == 'emergency' ||
                status == 'alert';
            final wasBad =
                _lastStatus == 'deviation' ||
                _lastStatus == 'emergency' ||
                _lastStatus == 'alert';

            if (isbadNow && !wasBad) {
              // 1. Start Pulse Animation
              _panicPulseController.repeat(reverse: true);

              // 2. Trigger Haptic Pattern (Use Timer for faster, consistent pulsing)
              // Rapid pulses for urgency
              int pulseCount = 0;
              Timer.periodic(const Duration(milliseconds: 150), (timer) {
                if (mounted && pulseCount < 6) {
                  // 6 rapid pulses
                  HapticFeedback.heavyImpact();
                  pulseCount++;
                } else {
                  timer.cancel();
                }
              });
            } else if (!isbadNow && wasBad) {
              // Stop effects if resolved
              _panicPulseController.stop();
              _panicPulseController.reset();
            }

            // Update tracker
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) setState(() => _lastStatus = status);
            });
          }

          return Stack(
            children: [
              // 1. Map Layer
              AnimatedBuilder(
                animation: _markerController,
                builder: (context, child) {
                  final animatedPos = _getAnimatedPosition(_animation.value);

                  // Handle Soft Follow Mode
                  if (_isFollowingUser) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _mapController.move(
                        animatedPos,
                        _mapController.camera.zoom,
                      );
                    });
                  }

                  return FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      // Initial center is ignored if controller moves it, but good for first render
                      initialCenter: animatedPos,
                      initialZoom: 16.0,
                      onMapEvent: (event) {
                        if (event.source == MapEventSource.onDrag ||
                            event.source == MapEventSource.onMultiFinger) {
                          if (_isFollowingUser) {
                            if (mounted) {
                              setState(() => _isFollowingUser = false);
                            }
                          }
                        }
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.naiklah_app',
                      ),
                      // Safe Route (Blue)
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: DemoRouteData.safeRoute,
                            strokeWidth: 6.0,
                            color: Colors.blue.withValues(alpha: 0.7),
                            strokeCap: StrokeCap.round,
                            strokeJoin: StrokeJoin.round,
                          ),
                          // Deviation Path (Red)
                          if (isOffRoute)
                            Polyline(
                              points: DemoRouteData.deviationPath,
                              strokeWidth: 6.0,
                              color: alertRed.withValues(alpha: 0.8),
                              strokeCap: StrokeCap.round,
                              strokeJoin: StrokeJoin.round,
                            ),
                        ],
                      ),
                      // Animated Marker Layer
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: animatedPos,
                            width: 60,
                            height: 60,
                            child: _buildVehicleIcon(isOffRoute),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),

              // 2. Alert Overlay (with Pulse)
              if (isOffRoute)
                AnimatedBuilder(
                  animation: _panicPulseController,
                  builder: (context, child) {
                    return Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        color: alertRed.withValues(
                          // Base opacity 0.6 + pulse up to 0.5 = max 1.1 (clamped to 1.0)
                          alpha: 0.6 + _panicPulseAnimation.value,
                        ),
                        child: SafeArea(
                          bottom: false,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.warning,
                                color: Colors.white,
                                size: 32,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      status == 'emergency'
                                          ? 'SOS ACTIVATED'
                                          : 'ROUTE DEVIATION',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      status == 'emergency'
                                          ? 'Notifying Guardian & Authorities...'
                                          : 'Sharing location with Guardian...',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

              // 3. Bottom Panel
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.isWalking
                                      ? 'Walking Route'
                                      : 'Bus 190 (SBS3928X)',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      size: 16,
                                      color: hotPink,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Next: Chinatown Stn',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: emeraldGreen.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'ON TIME',
                                style: TextStyle(
                                  color: emeraldGreen,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // PANIC BUTTON
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton.icon(
                            // Allow multiple clicks to spam the alert
                            onPressed: _triggerPanic,
                            icon: const Icon(
                              Icons.notifications_active,
                              size: 28,
                            ),
                            label: Text(
                              _isPanicActive
                                  ? 'SENDING ALERT...'
                                  : 'EMERGENCY ALERT',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isPanicActive
                                  ? alertRed.withValues(alpha: 0.8)
                                  : alertRed,
                              foregroundColor: Colors.white,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildVehicleIcon(bool isOffRoute) {
    return Container(
      decoration: BoxDecoration(
        color: isOffRoute ? alertRed : emeraldGreen,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        isOffRoute
            ? Icons.warning_amber_rounded
            : (widget.isWalking ? Icons.directions_walk : Icons.directions_bus),
        color: Colors.white,
        size: 32,
      ),
    );
  }
}
