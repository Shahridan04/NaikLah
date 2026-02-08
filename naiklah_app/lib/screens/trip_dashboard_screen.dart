import 'package:flutter/material.dart';
import '../models/trip_dashboard_model.dart';
import '../models/transport_model.dart';
import '../services/dashboard_data_service.dart';
import '../services/trip_data_service.dart';
import '../services/trip_simulation_service.dart';
import 'active_trip_screen.dart';
import 'trip_detail_screen.dart';

/// Trip Dashboard Screen - Complete implementation matching Figma
/// Includes: Transport selection, Recent Trips, Leaderboard, Achievements
class TripDashboardScreen extends StatefulWidget {
  final String? userGender;

  const TripDashboardScreen({super.key, this.userGender});

  @override
  State<TripDashboardScreen> createState() => _TripDashboardScreenState();
}

class _TripDashboardScreenState extends State<TripDashboardScreen> {
  // Brand colors
  static const Color emeraldGreen = Color(0xFF10B981);
  static const Color hotPink = Color(0xFFEC4899);
  static const Color navy = Color(0xFF1E3A5F);

  bool _filterWomenOnly = false;
  String? _selectedModeId;
  bool _showScanner = false;
  bool _tripLogged = false;
  TransportModeInfo? _loggedMode;

  bool get _isMale => widget.userGender == 'male';

  late List<TransportModeInfo> _transportModes;
  late List<RouteModel> _allRoutes;
  late List<TripRecord> _recentTrips;
  late List<LeaderboardEntry> _leaderboard;
  late List<Achievement> _achievements;

  @override
  void initState() {
    super.initState();
    var modes = DashboardDataService.getTransportModes();
    if (_isMale) {
      modes = modes.where((m) => !m.isWomenOnly).toList();
    }
    _transportModes = modes;

    var routes = TripDataService.getAvailableRoutes();
    if (_isMale) {
      routes = routes.where((r) => !r.isWomenOnly).toList();
    }
    _allRoutes = routes;

    _recentTrips = DashboardDataService.getRecentTrips();
    _leaderboard = DashboardDataService.getLeaderboard();
    _achievements = DashboardDataService.getAchievements();
  }

  List<RouteModel> get _filteredRoutes {
    if (_filterWomenOnly && !_isMale) {
      return _allRoutes.where((r) => r.isWomenOnly).toList();
    }
    return _allRoutes;
  }

  List<TransportModeInfo> get _filteredTransportModes {
    if (_filterWomenOnly && !_isMale) {
      return _transportModes.where((m) => m.isWomenOnly).toList();
    }
    return _transportModes;
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

  Widget _buildMainScreen() {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: navy,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Trips",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
            _buildTransportGrid(),
            const SizedBox(height: 24),

            // Available Routes
            _buildSectionTitle('Available Routes Near You'),
            const SizedBox(height: 12),
            _buildRoutesList(),
            const SizedBox(height: 24),

            // Manual Entry Option
            _buildManualEntryCard(),
            const SizedBox(height: 16),

            // Demo Controls (Hackathon Special)
            _buildDemoCard(),
            const SizedBox(height: 24),
            const SizedBox(height: 24),

            // Recent Trips Section
            _buildRecentTripsSection(),
            const SizedBox(height: 16),

            // Leaderboard Section
            _buildLeaderboardSection(),
            const SizedBox(height: 24),

            // Achievements
            _buildAchievementsSection(),
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
          color: _filterWomenOnly ? hotPink : Colors.grey.shade300,
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
            child: const Icon(Icons.shield, color: hotPink, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Women-Only Filter',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Show only women-only transport options',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Switch(
            value: _filterWomenOnly,
            onChanged: (v) => setState(() => _filterWomenOnly = v),
            activeColor: hotPink,
          ),
        ],
      ),
    );
  }

  /// Transport Mode Grid (matching Figma exactly)
  Widget _buildTransportGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.65, // Reduced from 0.85 to fix overflow
      ),
      itemCount: _filteredTransportModes.length,
      itemBuilder: (context, index) {
        final mode = _filteredTransportModes[index];
        final isSelected = _selectedModeId == mode.id;
        return _buildTransportCard(mode, isSelected);
      },
    );
  }

  Widget _buildTransportCard(TransportModeInfo mode, bool isSelected) {
    final cardColor = mode.isWomenOnly ? hotPink : emeraldGreen;

    return GestureDetector(
      onTap: () {
        if (mode.id == 'walking') {
          setState(() {
            _loggedMode = mode;
            _tripLogged = true;
          });
          return;
        }
        setState(() => _selectedModeId = mode.id);
        _showScanner = true;
        _loggedMode = mode;
        setState(() {});
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? cardColor.withValues(alpha: 0.1)
              : mode.isWomenOnly
              ? hotPink.withValues(alpha: 0.05)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? cardColor
                : mode.isWomenOnly
                ? hotPink.withValues(alpha: 0.3)
                : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Stack(
          children: [
            // Women Only badge
            if (mode.isWomenOnly)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: emeraldGreen,
                    borderRadius: BorderRadius.circular(10),
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
            // Card content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _getIconBgColor(mode.id),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getTransportIcon(mode.id),
                      color: _getIconColor(mode.id),
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Name
                  Text(
                    mode.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: mode.isWomenOnly ? hotPink : Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  // Description
                  Text(
                    mode.description,
                    style: TextStyle(fontSize: 9, color: Colors.grey.shade600),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Points
                  Text(
                    '+${mode.pointsPerTrip} pts',
                    style: TextStyle(
                      color: mode.isWomenOnly ? hotPink : emeraldGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  // CO2
                  Text(
                    '${mode.co2PerTripKg}kg CO₂',
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getTransportIcon(String id) {
    switch (id) {
      case 'pink_bus':
      case 'bus':
        return Icons.directions_bus;
      case 'lrt':
        return Icons.train;
      case 'ev_car':
        return Icons.electric_car;
      case 'walking':
        return Icons.directions_walk;
      case 'carpool':
        return Icons.people;
      default:
        return Icons.directions;
    }
  }

  Color _getIconBgColor(String id) {
    switch (id) {
      case 'pink_bus':
        return hotPink.withValues(alpha: 0.2);
      case 'bus':
        return Colors.blue.withValues(alpha: 0.2);
      case 'lrt':
        return Colors.amber.withValues(alpha: 0.2);
      case 'ev_car':
        return emeraldGreen.withValues(alpha: 0.2);
      case 'walking':
        return emeraldGreen.withValues(alpha: 0.2);
      case 'carpool':
        return Colors.orange.withValues(alpha: 0.2);
      default:
        return Colors.grey.withValues(alpha: 0.2);
    }
  }

  Color _getIconColor(String id) {
    switch (id) {
      case 'pink_bus':
        return hotPink;
      case 'bus':
        return Colors.blue;
      case 'lrt':
        return Colors.amber.shade700;
      case 'ev_car':
        return emeraldGreen;
      case 'walking':
        return emeraldGreen;
      case 'carpool':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  /// Available Routes List
  Widget _buildRoutesList() {
    return Column(
      children: _filteredRoutes.take(3).map((route) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildRouteCard(route),
        );
      }).toList(),
    );
  }

  Widget _buildRouteCard(RouteModel route) {
    final isPink = route.isWomenOnly;
    final borderColor = isPink ? hotPink : Colors.grey.shade200;
    final buttonColor = isPink ? hotPink : navy;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: isPink ? 2 : 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: emeraldGreen,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                '♀ Women Only',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        route.type,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
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
                          route.safetyRating.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Safety Rating',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Info row
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  'Next Arrival',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
                const SizedBox(width: 4),
                Text(
                  route.nextArrival,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                Icon(Icons.check_circle, size: 16, color: emeraldGreen),
                const SizedBox(width: 4),
                Text(
                  'Real-time',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
                const SizedBox(width: 4),
                Text(
                  'GPS Tracked',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    color: emeraldGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Feature chips
            if (route.features.isNotEmpty)
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: route.features.map((f) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(f, style: const TextStyle(fontSize: 10)),
                  );
                }).toList(),
              ),
            const SizedBox(height: 12),
            // Scan button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() => _showScanner = true);
                },
                icon: const Icon(Icons.qr_code, size: 18),
                label: const Text('Scan QR Code to Board'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
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
      ),
    );
  }

  /// Manual Entry Card
  Widget _buildManualEntryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.location_on, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Can't find a QR code?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "You can manually log your trip. We'll verify it through GPS tracking.",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black87,
              side: BorderSide(color: Colors.grey.shade400),
            ),
            child: const Text('Manual Entry'),
          ),
        ],
      ),
    );
  }

  /// Recent Trips Section
  Widget _buildRecentTripsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Trips',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View All',
                  style: TextStyle(color: Colors.blue.shade600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ..._recentTrips.take(4).map((trip) => _buildTripItem(trip)),
        ],
      ),
    );
  }

  Widget _buildTripItem(TripRecord trip) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TripDetailScreen(trip: trip),
            ),
          );
        },
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: trip.transportMode == 'pink_bus'
                    ? hotPink.withValues(alpha: 0.2)
                    : emeraldGreen.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.directions_bus,
                color: trip.transportMode == 'pink_bus'
                    ? hotPink
                    : emeraldGreen,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trip.routeName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    trip.formattedTime,
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '+${trip.pointsEarned} pts',
                  style: TextStyle(
                    color: emeraldGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Text(
                  '${trip.co2Saved}kg CO₂ saved',
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Leaderboard Section
  Widget _buildLeaderboardSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.emoji_events, color: Colors.amber, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Leaderboard',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._leaderboard.map((entry) => _buildLeaderboardItem(entry)),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.grey.shade700,
                side: BorderSide(color: Colors.grey.shade300),
              ),
              child: const Text('View Full Leaderboard'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardItem(LeaderboardEntry entry) {
    Color rankColor = Colors.grey.shade600;
    Color bgColor = Colors.transparent;

    if (entry.rank == 1) {
      rankColor = Colors.amber;
    } else if (entry.rank == 2) {
      rankColor = Colors.grey;
    } else if (entry.rank == 3) {
      rankColor = Colors.orange.shade700;
    }

    if (entry.isCurrentUser) {
      bgColor = Colors.amber.withValues(alpha: 0.2);
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: entry.isCurrentUser
            ? Border.all(color: Colors.amber.shade300)
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: entry.rank <= 3
                  ? rankColor.withValues(alpha: 0.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '${entry.rank}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: entry.rank <= 3 ? rankColor : Colors.grey.shade700,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              entry.name,
              style: TextStyle(
                fontWeight: entry.isCurrentUser
                    ? FontWeight.bold
                    : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ),
          Text(
            '${entry.points} pts',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }

  /// Achievements Section
  Widget _buildAchievementsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Achievements'),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _achievements.map((a) {
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _buildAchievementCard(a),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementCard(Achievement achievement) {
    final bgColor = achievement.isEarned
        ? Colors.amber.withValues(alpha: 0.1)
        : Colors.grey.shade100;
    final borderColor = achievement.isEarned
        ? Colors.amber.shade300
        : Colors.grey.shade300;

    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Text(achievement.iconEmoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 8),
          Text(
            achievement.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            textAlign: TextAlign.center,
          ),
          Text(
            achievement.description,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          if (achievement.isEarned)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check, color: emeraldGreen, size: 14),
                const SizedBox(width: 4),
                Text(
                  'Earned',
                  style: TextStyle(
                    color: emeraldGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ],
            )
          else if (achievement.progress != null && achievement.total != null)
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: achievement.progress! / achievement.total!,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(hotPink),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${achievement.progress}/${achievement.total}',
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                ),
              ],
            ),
        ],
      ),
    );
  }

  /// QR Scanner Screen
  Widget _buildScannerScreen() {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => setState(() => _showScanner = false),
        ),
        title: const Text(
          'Scan QR Code',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                border: Border.all(color: hotPink, width: 3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.qr_code_scanner,
                size: 120,
                color: Colors.white54,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Point camera at QR code',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 48),
            // Simulate scan button
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _tripLogged = true;
                  _showScanner = false;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: emeraldGreen,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Simulate Scan'),
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
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [emeraldGreen, emeraldGreen.withValues(alpha: 0.8)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check, size: 64, color: emeraldGreen),
                ),
                const SizedBox(height: 32),
                Text(
                  _loggedMode?.id == 'walking'
                      ? 'Walk Completed!'
                      : 'Trip Logged!',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (_loggedMode?.id == 'walking') ...[
                  const SizedBox(height: 8),
                  const Text(
                    '2.4 km walked today 🏃‍♀️',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Text(
                  'You earned +${_loggedMode?.pointsPerTrip ?? 50} points',
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  'CO₂ saved: ${_loggedMode?.co2PerTripKg ?? 0.8}kg',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _tripLogged = false;
                        _showScanner = false;
                        _loggedMode = null;
                        _selectedModeId = null;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: emeraldGreen,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Log Another Trip',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Back to Home',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDemoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.science, color: Colors.amber, size: 24),
              const SizedBox(width: 12),
              const Text(
                'Demo Controls',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Simulate a trip for the Guardian to track.',
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 16),
          // SAFE TRIP BUTTON
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                // 1. Start simulation (Safe)
                await TripSimulationService().startSimulation(
                  triggerDeviation: false,
                );

                // 2. Navigate to Active Trip Screen (Daughter's View)
                if (context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ActiveTripScreen()),
                  );
                }
              },
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Start Safe Trip (No Deviation)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: emeraldGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // RISKY TRIP BUTTON
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                // 1. Start simulation (Risky)
                await TripSimulationService().startSimulation(
                  triggerDeviation: true,
                );

                // 2. Navigate to Active Trip Screen (Daughter's View)
                if (context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ActiveTripScreen()),
                  );
                }
              },
              icon: const Icon(Icons.warning_amber_rounded),
              label: const Text('Start Risky Trip (With Deviation 🚨)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
