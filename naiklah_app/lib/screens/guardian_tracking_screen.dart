import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/demo_route_data.dart';

class GuardianTrackingScreen extends StatefulWidget {
  const GuardianTrackingScreen({super.key});

  @override
  State<GuardianTrackingScreen> createState() => _GuardianTrackingScreenState();
}

class _GuardianTrackingScreenState extends State<GuardianTrackingScreen>
    with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  final String _tripId = 'demo_trip';

  // Animation State
  late AnimationController _markerController;
  late Animation<double> _animation;
  LatLng _currentMarkerPos = const LatLng(3.147271, 101.699533);
  LatLng _targetMarkerPos = const LatLng(3.147271, 101.699533);

  bool _isFollowingUser = true; // State for Follow Mode

  @override
  void initState() {
    super.initState();
    // Initialize Animation Controller
    _markerController = AnimationController(
      duration: const Duration(seconds: 1), // duration matches update interval
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _markerController,
      curve: Curves.linear,
    );
  }

  @override
  void dispose() {
    _markerController.dispose();
    super.dispose();
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Guardian Mode',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withValues(alpha: 0.9),
                Colors.white.withValues(alpha: 0.0),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: null,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('trips')
            .doc(_tripId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>?;
          final status = data?['status'] as String? ?? 'ended';
          final locationData =
              data?['currentLocation'] as Map<String, dynamic>?;

          if (!snapshot.hasData ||
              !snapshot.data!.exists ||
              status != 'active' ||
              locationData == null) {
            return _buildEmptyState();
          }

          final isDeviation = data?['isDeviation'] as bool? ?? false;
          final lat = locationData['latitude'] as double;
          final lng = locationData['longitude'] as double;
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

          return Stack(
            children: [
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
                      // Draw Safe Route (Polyline)
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: DemoRouteData.safeRoute,
                            strokeWidth: 6.0,
                            color: Colors.blue.withValues(alpha: 0.6),
                            borderColor: Colors.blue.shade900,
                            borderStrokeWidth: 1.0,
                            strokeCap: StrokeCap.round,
                            strokeJoin: StrokeJoin.round,
                          ),
                        ],
                      ),
                      // Current Bus Marker with Smooth Animation
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: animatedPos,
                            width: 100,
                            height: 100,
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.2,
                                        ),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: const Text(
                                    "Pink Bus 01",
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.pink,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.directions_bus,
                                  color: Colors.pink, // "Pink Bus"
                                  size: 48,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),

              // Re-center Button (Top Right)
              if (!_isFollowingUser)
                Positioned(
                  top: 100,
                  right: 16,
                  child: FloatingActionButton.small(
                    onPressed: () => setState(() => _isFollowingUser = true),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.pink,
                    child: const Icon(Icons.center_focus_strong),
                  ),
                ),

              // Bus Detail & Status Card
              Positioned(
                bottom: 30,
                left: 16,
                right: 16,
                child: Column(
                  children: [
                    _buildDriverInfoCard(),
                    const SizedBox(height: 12),
                    _buildStatusCard(status, isDeviation),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.directions_bus_outlined,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            'Waiting for trip to start...',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back soon for Sarah\'s trip status',
            style: TextStyle(color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverInfoCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.pinkAccent,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Driver: Pn. Siti",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  "Plate: WXX 1234",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.access_time, size: 14, color: Colors.purple),
                SizedBox(width: 4),
                Text(
                  "5 min away",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(String status, bool isDeviation) {
    Color iconColor = Colors.green;
    IconData icon = Icons.check_circle;
    String title = "On Route";
    String subtitle = "Sarah is on the correct path";

    if (isDeviation || status == 'alert') {
      iconColor = Colors.red;
      icon = Icons.warning_rounded;
      title = "ROUTE DEVIATION ALERT";
      subtitle = "Bus has veered off the safe route!";
    } else if (status == 'ended') {
      iconColor = Colors.grey;
      icon = Icons.flag;
      title = "Trip Ended";
      subtitle = "Sarah has arrived safely.";
    }

    return Card(
      color: isDeviation ? Colors.red : Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDeviation
                    ? Colors.white
                    : iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isDeviation ? Colors.red : iconColor,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDeviation ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDeviation
                          ? Colors.white.withValues(alpha: 0.9)
                          : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
