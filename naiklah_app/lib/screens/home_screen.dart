import 'package:flutter/material.dart';
import '../services/user_service.dart';

import 'map_screen.dart';
import 'rewards_screen.dart';
import 'trip_dashboard_screen.dart';
import 'login_screen.dart';
import 'guardian_tracking_screen.dart';
import 'child_ride_history_screen.dart';
import 'guardian_support_screen.dart';
import 'profile_screen.dart';

/// Home Screen with Bottom Navigation
/// Main entry point with tabs for Map, Trips, Rewards, Profile
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
  Color get _themeColor {
    final user = UserService().currentUser;
    if (user == null) return emeraldGreen; // Default
    return user.isMale ? maleBlue : hotPink;
  }

  List<Widget> get _screens {
    final user = UserService().currentUser;
    final isGuardian = user?.isGuardian ?? false;
    final userGender = user?.gender;

    if (isGuardian) {
      return [
        const GuardianTrackingScreen(), // Guardian sees tracking screen first
        const ChildRideHistoryScreen(), // Ride History
        const GuardianSupportScreen(), // Support & Contact
        ProfileScreen(userGender: userGender, onLogout: _logout),
      ];
    }
    return [
      MapScreen(userGender: userGender),
      TripDashboardScreen(userGender: userGender),
      const RewardsScreen(),
      ProfileScreen(userGender: userGender, onLogout: _logout),
    ];
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
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
          items: [
            if (UserService().currentUser?.isGuardian ?? false) ...[
              const BottomNavigationBarItem(
                icon: Icon(Icons.map_outlined),
                activeIcon: Icon(Icons.map),
                label: 'Tracking',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.history_outlined),
                activeIcon: Icon(Icons.history),
                label: 'History',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.contact_support_outlined),
                activeIcon: Icon(Icons.contact_support),
                label: 'Support',
              ),
            ] else ...[
              const BottomNavigationBarItem(
                icon: Icon(Icons.map_outlined),
                activeIcon: Icon(Icons.map),
                label: 'Map',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.directions_bus_outlined),
                activeIcon: Icon(Icons.directions_bus),
                label: 'Trips',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.card_giftcard_outlined),
                activeIcon: Icon(Icons.card_giftcard),
                label: 'Rewards',
              ),
            ],
            const BottomNavigationBarItem(
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
