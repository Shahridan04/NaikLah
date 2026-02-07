import 'package:flutter/material.dart';
import '../models/transport_model.dart';
import '../services/trip_data_service.dart';

/// Trip Logging Screen - Based on Figma design
/// Allows users to select transport mode and log trips
class TripLoggingScreen extends StatefulWidget {
  final String? userGender;

  const TripLoggingScreen({super.key, this.userGender});

  @override
  State<TripLoggingScreen> createState() => _TripLoggingScreenState();
}

class _TripLoggingScreenState extends State<TripLoggingScreen> {
  // Brand colors
  static const Color emeraldGreen = Color(0xFF10B981);
  static const Color hotPink = Color(0xFFEC4899);

  bool _filterWomenOnly = false;
  String? _selectedModeId;
  bool _showScanner = false;
  bool _tripLogged = false;
  TransportMode? _loggedMode;

  // Check if user is male (shouldn't see Pink Bus options)
  bool get _isMale => widget.userGender == 'male';

  late List<TransportMode> _transportModes;
  late List<RouteModel> _allRoutes;

  @override
  void initState() {
    super.initState();
    // Filter out women-only modes for men
    var modes = TripDataService.getTransportModes();
    if (_isMale) {
      modes = modes.where((m) => !m.isWomenOnly).toList();
    }
    _transportModes = modes;

    // Filter out women-only routes for men
    var routes = TripDataService.getAvailableRoutes();
    if (_isMale) {
      routes = routes.where((r) => !r.isWomenOnly).toList();
    }
    _allRoutes = routes;
  }

  List<RouteModel> get _filteredRoutes {
    if (_filterWomenOnly && !_isMale) {
      return _allRoutes.where((r) => r.isWomenOnly).toList();
    }
    return _allRoutes;
  }

  @override
  Widget build(BuildContext context) {
    if (_tripLogged && _loggedMode != null) {
      return _buildTripSuccessScreen();
    }
    if (_showScanner) {
      return _buildScannerScreen();
    }
    return _buildMainScreen();
  }

  /// Main Trip Logging Screen
  Widget _buildMainScreen() {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Log Your Trip',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Choose your transport mode and start earning',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Women-Only Filter (only for women)
            if (!_isMale) _buildWomenOnlyFilter(),
            if (!_isMale) const SizedBox(height: 24),
            // Transport Mode Selection
            _buildSectionTitle('Select Transport Mode'),
            const SizedBox(height: 12),
            _buildTransportModeGrid(),
            const SizedBox(height: 24),
            // Available Routes
            _buildSectionTitle('Available Routes Near You'),
            const SizedBox(height: 12),
            _buildRoutesList(),
            const SizedBox(height: 24),
            // Manual Entry Option
            _buildManualEntryCard(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  /// Women-Only Filter Toggle
  Widget _buildWomenOnlyFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _filterWomenOnly ? hotPink.withValues(alpha: 0.1) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _filterWomenOnly ? hotPink : Colors.grey.shade200,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: hotPink.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.shield, color: hotPink, size: 24),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Women-Only Filter',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  'Show only women-only transport options',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Switch(
            value: _filterWomenOnly,
            onChanged: (value) => setState(() => _filterWomenOnly = value),
            activeColor: hotPink,
          ),
        ],
      ),
    );
  }

  /// Transport Mode Grid
  Widget _buildTransportModeGrid() {
    final modes = _filterWomenOnly
        ? _transportModes.where((m) => m.isWomenOnly).toList()
        : _transportModes;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.65,
      ),
      itemCount: modes.length,
      itemBuilder: (context, index) => _buildTransportModeCard(modes[index]),
    );
  }

  Widget _buildTransportModeCard(TransportMode mode) {
    final isSelected = _selectedModeId == mode.id;
    final cardColor = mode.isWomenOnly ? hotPink : _getModeColor(mode.iconType);

    return GestureDetector(
      onTap: () => _handleModeTap(mode),
      child: Container(
        decoration: BoxDecoration(
          color: mode.isWomenOnly
              ? hotPink.withValues(alpha: 0.05)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? cardColor
                : mode.isWomenOnly
                ? hotPink.withValues(alpha: 0.3)
                : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: cardColor.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: cardColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _getModeIcon(mode.iconType, cardColor),
                    ),
                    const SizedBox(height: 6),
                    // Title
                    Text(
                      mode.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    // Description
                    Text(
                      mode.description,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 9,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    // Points & CO2
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '+${mode.points} pts',
                          style: TextStyle(
                            color: emeraldGreen,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          '${mode.co2Saved}kg',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Women Only Badge (overlay)
            if (mode.isWomenOnly)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: hotPink,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '♀ Women Only',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Routes List
  Widget _buildRoutesList() {
    if (_filteredRoutes.isEmpty) {
      return _buildNoRoutesCard();
    }

    return Column(
      children: _filteredRoutes.map((route) => _buildRouteCard(route)).toList(),
    );
  }

  Widget _buildRouteCard(RouteModel route) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: route.isWomenOnly
            ? Border.all(color: hotPink.withValues(alpha: 0.3), width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            route.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        if (route.isWomenOnly) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: hotPink,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.shield,
                                  color: Colors.white,
                                  size: 10,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Women Only',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      route.type,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              // Safety Rating
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${route.safetyRating}',
                        style: const TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Safety Rating',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Info Row
          Row(
            children: [
              _buildInfoChip(
                Icons.access_time,
                'Next Arrival',
                route.nextArrival,
                Colors.blue,
              ),
              const SizedBox(width: 16),
              _buildInfoChip(
                Icons.navigation,
                'Real-time',
                'GPS Tracked',
                emeraldGreen,
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Features
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: route.features.map((f) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  f,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          // Scan Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () =>
                  _handleScanQR(route.isWomenOnly ? 'pink-bus' : 'bus'),
              icon: const Icon(Icons.qr_code),
              label: const Text('Scan QR Code to Board'),
              style: ElevatedButton.styleFrom(
                backgroundColor: route.isWomenOnly
                    ? hotPink
                    : Colors.grey.shade900,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 10),
            ),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNoRoutesCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.shade200, width: 2),
      ),
      child: Column(
        children: [
          Icon(Icons.info_outline, color: Colors.amber.shade700, size: 48),
          const SizedBox(height: 16),
          const Text(
            'No women-only routes available right now',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Try disabling the women-only filter to see all available routes',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => setState(() => _filterWomenOnly = false),
            style: ElevatedButton.styleFrom(
              backgroundColor: hotPink,
              foregroundColor: Colors.white,
            ),
            child: const Text('Show All Routes'),
          ),
        ],
      ),
    );
  }

  Widget _buildManualEntryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.location_on, color: Colors.grey.shade600, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Can't find a QR code?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "You can manually log your trip. We'll verify it through GPS tracking.",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Manual Entry'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Scanner Screen
  Widget _buildScannerScreen() {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text(
                    'Scanning QR Code',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Point your camera at the QR code',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: hotPink, width: 4),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Icon(Icons.qr_code, color: Colors.white54, size: 100),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: hotPink,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Scanning...',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => setState(() => _showScanner = false),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Trip Success Screen
  Widget _buildTripSuccessScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [emeraldGreen.withValues(alpha: 0.1), Colors.white],
          ),
        ),
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: emeraldGreen.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: emeraldGreen,
                    size: 64,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Trip Logged! 🎉',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Great job taking sustainable transport!',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.purple.shade50,
                        hotPink.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '+${_loggedMode!.points} Points',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('${_loggedMode!.co2Saved}kg CO₂ saved'),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star, color: Colors.orange.shade600),
                          const SizedBox(width: 4),
                          Text(
                            '10-day streak maintained!',
                            style: TextStyle(
                              color: Colors.orange.shade600,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => setState(() {
                      _tripLogged = false;
                      _loggedMode = null;
                      _selectedModeId = null;
                    }),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: emeraldGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Back to Home'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helpers
  void _handleModeTap(TransportMode mode) {
    setState(() => _selectedModeId = mode.id);
    _handleScanQR(mode.id);
  }

  void _handleScanQR(String modeId) {
    setState(() => _showScanner = true);
    // Simulate QR scan
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        final mode = _transportModes.firstWhere((m) => m.id == modeId);
        setState(() {
          _showScanner = false;
          _tripLogged = true;
          _loggedMode = mode;
        });
      }
    });
  }

  Icon _getModeIcon(String type, Color color) {
    IconData icon;
    switch (type) {
      case 'bus':
        icon = Icons.directions_bus;
        break;
      case 'train':
        icon = Icons.train;
        break;
      case 'bike':
        icon = Icons.pedal_bike;
        break;
      case 'walk':
        icon = Icons.directions_walk;
        break;
      case 'carpool':
        icon = Icons.directions_car;
        break;
      default:
        icon = Icons.directions;
    }
    return Icon(icon, color: color, size: 28);
  }

  Color _getModeColor(String type) {
    switch (type) {
      case 'bus':
        return Colors.blue;
      case 'train':
        return Colors.purple;
      case 'bike':
        return emeraldGreen;
      case 'walk':
        return Colors.teal;
      case 'carpool':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
