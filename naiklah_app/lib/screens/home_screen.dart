import 'package:flutter/material.dart';
import 'map_screen.dart';
import 'rewards_screen.dart';
import 'trip_dashboard_screen.dart';
import 'welcome_screen.dart';

/// Home Screen with Bottom Navigation
/// Main entry point with tabs for Map, Trips, Rewards, Profile
class HomeScreen extends StatefulWidget {
  final String? userGender;

  const HomeScreen({super.key, this.userGender});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Brand colors
  static const Color emeraldGreen = Color(0xFF10B981);
  static const Color hotPink = Color(0xFFEC4899);
  static const Color maleBlue = Color(0xFF3B82F6);

  // Get theme color based on gender
  Color get _themeColor => widget.userGender == 'male' ? maleBlue : hotPink;

  List<Widget> get _screens => [
    MapScreen(userGender: widget.userGender),
    TripDashboardScreen(userGender: widget.userGender),
    const RewardsScreen(),
    ProfilePlaceholder(userGender: widget.userGender, onLogout: _logout),
  ];

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: emeraldGreen,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined),
              activeIcon: Icon(Icons.map),
              label: 'Map',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_bus_outlined),
              activeIcon: Icon(Icons.directions_bus),
              label: 'Trips',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.card_giftcard_outlined),
              activeIcon: Icon(Icons.card_giftcard),
              label: 'Rewards',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                setState(() => _currentIndex = 1); // Go to Trips
              },
              backgroundColor: _themeColor,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }
}

/// Placeholder Profile Screen
class ProfilePlaceholder extends StatelessWidget {
  final String? userGender;
  final VoidCallback? onLogout;

  const ProfilePlaceholder({super.key, this.userGender, this.onLogout});

  static const Color emeraldGreen = Color(0xFF10B981);
  static const Color hotPink = Color(0xFFEC4899);
  static const Color maleBlue = Color(0xFF3B82F6);

  Color get _themeColor => userGender == 'male' ? maleBlue : hotPink;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [emeraldGreen, emeraldGreen.withValues(alpha: 0.8)],
            stops: const [0.0, 0.3],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Profile Header
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 50, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              const Text(
                'Sarah Johnson',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Gold Member',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),
              // Stats Row
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(20),
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('1,250', 'Points', hotPink),
                    _buildDivider(),
                    _buildStatItem('45', 'Trips', emeraldGreen),
                    _buildDivider(),
                    _buildStatItem('28.5kg', 'CO₂ Saved', Colors.blue),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Menu Items
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildMenuItem(Icons.history, 'Trip History'),
                      _buildMenuItem(Icons.shield, 'Guardian Mode'),
                      _buildMenuItem(Icons.notifications, 'Notifications'),
                      _buildMenuItem(Icons.settings, 'Settings'),
                      _buildMenuItem(Icons.help, 'Help & Support'),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: onLogout,
                          icon: const Icon(Icons.logout, color: Colors.red),
                          label: const Text(
                            'Sign Out',
                            style: TextStyle(color: Colors.red),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 40, color: Colors.grey.shade200);
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey.shade700),
      title: Text(title),
      trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
      onTap: () {},
    );
  }
}
