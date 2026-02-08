import 'package:flutter/material.dart';

class GuardianSupportScreen extends StatelessWidget {
  const GuardianSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Support & Contact',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Emergency Contacts',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 12),
            _buildContactCard(
              icon: Icons.local_police,
              title: 'Police',
              subtitle: '999',
              color: Colors.blue.shade900,
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _buildContactCard(
              icon: Icons.local_hospital,
              title: 'Ambulance',
              subtitle: '999',
              color: Colors.red,
              onTap: () {},
            ),
            const SizedBox(height: 24),
            const Text(
              'Ride Support',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            _buildContactCard(
              icon: Icons.person,
              title: 'Driver (Ali bin Abu)',
              subtitle: '012-3456789',
              color: Colors.green,
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _buildContactCard(
              icon: Icons.school,
              title: 'School Office',
              subtitle: '03-12345678',
              color: Colors.orange,
              onTap: () {},
            ),
            const SizedBox(height: 24),
            Center(
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'Report an Issue with the App',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.phone, color: Colors.green.shade700),
        onTap: onTap,
      ),
    );
  }
}
