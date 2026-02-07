import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/bus_model.dart';
import '../services/mock_data_service.dart';

/// MapScreen - Main map view with Pink Safety Filter
/// Displays bus locations on OpenStreetMap with toggle for women-only buses
class MapScreen extends StatefulWidget {
  final String? userGender;

  const MapScreen({super.key, this.userGender});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Brand colors from PRD
  static const Color emeraldGreen = Color(0xFF10B981);
  static const Color hotPink = Color(0xFFEC4899);

  // Filter state
  bool _pinkFilterEnabled = false;

  // Check if user is male (shouldn't see Pink Bus options)
  bool get _isMale => widget.userGender == 'male';

  // All buses from mock data (filtered to exclude Pink buses for men)
  List<BusModel> get _allBuses {
    final buses = MockDataService.getBuses();
    if (_isMale) {
      // Men don't see Pink buses at all
      return buses.where((bus) => !bus.isPink).toList();
    }
    return buses;
  }

  // Map controller
  final MapController _mapController = MapController();

  // Get filtered buses based on Pink Safety Filter
  List<BusModel> get _filteredBuses {
    if (_pinkFilterEnabled && !_isMale) {
      return _allBuses.where((bus) => bus.isPink).toList();
    }
    return _allBuses;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map Layer (Bottom)
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(
                MockDataService.klCenterLat,
                MockDataService.klCenterLng,
              ),
              initialZoom: 14.0,
              minZoom: 10.0,
              maxZoom: 18.0,
            ),
            children: [
              // OpenStreetMap Tile Layer
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.naiklah.app',
              ),
              // Bus Markers Layer
              MarkerLayer(markers: _buildBusMarkers()),
            ],
          ),

          // Pink Safety Filter Card (Top)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Filter Toggle Card (only for women)
                  if (!_isMale) _buildFilterCard(),
                  const Spacer(),
                  // Legend Card
                  _buildLegendCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build bus markers for the map
  List<Marker> _buildBusMarkers() {
    return _filteredBuses.map((bus) {
      return Marker(
        point: LatLng(bus.lat, bus.lng),
        width: 50,
        height: 50,
        child: GestureDetector(
          onTap: () => _showBusDetails(bus),
          child: _buildBusMarkerWidget(bus),
        ),
      );
    }).toList();
  }

  /// Build individual bus marker widget
  Widget _buildBusMarkerWidget(BusModel bus) {
    final Color markerColor = bus.isPink ? hotPink : emeraldGreen;

    return Container(
      decoration: BoxDecoration(
        color: markerColor,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: markerColor.withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        bus.isPink ? Icons.female : Icons.directions_bus,
        color: Colors.white,
        size: 24,
      ),
    );
  }

  /// Build the Pink Safety Filter toggle card
  Widget _buildFilterCard() {
    return Container(
      decoration: BoxDecoration(
        color: _pinkFilterEnabled
            ? hotPink.withValues(alpha: 0.1)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _pinkFilterEnabled ? hotPink : Colors.grey.shade300,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Shield Icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: hotPink.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.shield, color: hotPink, size: 24),
            ),
            const SizedBox(width: 12),
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Women-Only Filter',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'Show only women-only transport options',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            // Toggle Switch
            Switch(
              value: _pinkFilterEnabled,
              onChanged: (value) {
                setState(() {
                  _pinkFilterEnabled = value;
                });
              },
              activeColor: hotPink,
              activeTrackColor: hotPink.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }

  /// Build legend card showing marker colors
  Widget _buildLegendCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Pink Bus Legend
            _buildLegendItem(hotPink, 'Pink Bus', Icons.female),
            const SizedBox(width: 20),
            // Regular Bus Legend
            if (!_pinkFilterEnabled)
              _buildLegendItem(emeraldGreen, 'Regular', Icons.directions_bus),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Icon(icon, color: Colors.white, size: 16),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  /// Show bus details bottom sheet
  void _showBusDetails(BusModel bus) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: bus.isPink
                          ? hotPink.withValues(alpha: 0.2)
                          : emeraldGreen.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      bus.isPink ? Icons.female : Icons.directions_bus,
                      color: bus.isPink ? hotPink : emeraldGreen,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                bus.routeName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (bus.isPink) ...[
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
                                      size: 12,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Women Only',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
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
                          'Driver: ${bus.driverGender}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Info Row
              Row(
                children: [
                  // Next Arrival
                  Expanded(
                    child: _buildInfoTile(
                      Icons.access_time,
                      'Next Arrival',
                      bus.nextArrival ?? 'Unknown',
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Safety Rating
                  Expanded(
                    child: _buildInfoTile(
                      Icons.star,
                      'Safety Rating',
                      bus.safetyRating?.toString() ?? 'N/A',
                      Colors.amber,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Features
              if (bus.features != null && bus.features!.isNotEmpty) ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: bus.features!.map((feature) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        feature,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
              ],
              // Board Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(Icons.qr_code, color: Colors.white),
                            const SizedBox(width: 12),
                            Text('Scan QR to board ${bus.routeName}'),
                          ],
                        ),
                        backgroundColor: bus.isPink ? hotPink : emeraldGreen,
                      ),
                    );
                  },
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Scan QR Code to Board'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: bus.isPink ? hotPink : emeraldGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoTile(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
