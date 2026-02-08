import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';
import 'edit_profile_screen.dart';
import 'login_screen.dart';
import 'accessibility_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const Color emeraldGreen = Color(0xFF10B981);
  static const Color hotPink = Color(0xFFEC4899);
  static const Color maleBlue = Color(0xFF3B82F6);

  // Get theme color based on gender
  Color get _themeColor {
    final user = UserService().currentUser;
    if (user == null) return emeraldGreen;
    return user.isMale ? maleBlue : hotPink;
  }

  void _logout() {
    UserService().logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<UserModel?>(
      valueListenable: UserService().currentUserNotifier,
      builder: (context, user, child) {
        if (user == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          appBar: AppBar(
            title: const Text(
              'Profile & Settings',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Profile Header
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  color: Colors.white,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: _themeColor.withValues(alpha: 0.1),
                        backgroundImage: user.profilePictureUrl != null
                            ? NetworkImage(user.profilePictureUrl!)
                            : null,
                        child: user.profilePictureUrl == null
                            ? Icon(Icons.person, size: 40, color: _themeColor)
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  user.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.green.shade200,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.verified_user,
                                        size: 12,
                                        color: Colors.green,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Verified',
                                        style: TextStyle(
                                          color: Colors.green.shade700,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user.email,
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                            if (user.phoneNumber != null)
                              Text(
                                user.phoneNumber!,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const EditProfileScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit_outlined),
                        color: _themeColor,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Membership Card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [_themeColor, _themeColor.withValues(alpha: 0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: _themeColor.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'NaikLah Points',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            user.points.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.card_giftcard,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Settings List
                _buildSectionHeader('General'),
                _buildListTile(Icons.history, 'Trip History', onTap: () {}),
                _buildListTile(
                  Icons.accessibility_new_outlined,
                  'Accessibility',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AccessibilityScreen(),
                      ),
                    );
                  },
                ),
                _buildListTile(
                  Icons.notifications_outlined,
                  'Notifications',
                  trailing: Switch(
                    value: true,
                    onChanged: (v) {},
                    activeColor: _themeColor,
                  ),
                ),
                _buildListTile(
                  Icons.language,
                  'Language',
                  trailing: const Text(
                    'English',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),

                const SizedBox(height: 16),
                _buildSectionHeader('Support'),
                _buildListTile(Icons.help_outline, 'Help Center', onTap: () {}),
                _buildListTile(
                  Icons.privacy_tip_outlined,
                  'Privacy Policy',
                  onTap: () {},
                ),
                _buildListTile(Icons.info_outline, 'About Us', onTap: () {}),

                const SizedBox(height: 24),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _logout,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Log Out'),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title.toUpperCase(),
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildListTile(
    IconData icon,
    String title, {
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 1),
      child: ListTile(
        leading: Icon(icon, color: Colors.grey.shade700),
        title: Text(title),
        trailing:
            trailing ?? const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      ),
    );
  }
}
