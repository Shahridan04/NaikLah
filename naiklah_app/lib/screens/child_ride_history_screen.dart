import 'package:flutter/material.dart';
import '../models/trip_dashboard_model.dart';
import '../services/dashboard_data_service.dart';

class ChildRideHistoryScreen extends StatefulWidget {
  const ChildRideHistoryScreen({super.key});

  @override
  State<ChildRideHistoryScreen> createState() => _ChildRideHistoryScreenState();
}

class _ChildRideHistoryScreenState extends State<ChildRideHistoryScreen> {
  static const Color hotPink = Color(0xFFEC4899);
  static const Color emeraldGreen = Color(0xFF10B981);

  late List<TripRecord> _rideHistory;

  @override
  void initState() {
    super.initState();
    // Using the existing service to get mock data
    _rideHistory = DashboardDataService.getRecentTrips();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sarah\'s Ride History',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple.shade50, Colors.white],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _rideHistory.length,
          itemBuilder: (context, index) {
            final ride = _rideHistory[index];
            return _buildRideCard(ride);
          },
        ),
      ),
    );
  }

  Widget _buildRideCard(TripRecord ride) {
    bool isPinkBus = ride.transportMode == 'pink_bus';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isPinkBus ? hotPink.withOpacity(0.3) : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isPinkBus
                        ? hotPink.withOpacity(0.1)
                        : emeraldGreen.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isPinkBus ? Icons.directions_bus : Icons.directions_transit,
                    color: isPinkBus ? hotPink : emeraldGreen,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ride.routeName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        ride.formattedTime,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: const Text(
                    'COMPLETED',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildRideDetail(
                  Icons.access_time,
                  'Duration',
                  '25 mins',
                ), // Mock data
                _buildRideDetail(
                  Icons.attach_money,
                  'Cost',
                  'RM 2.50',
                ), // Mock data
                _buildRideDetail(
                  Icons.speed,
                  'Avg Speed',
                  '40 km/h',
                ), // Mock data
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRideDetail(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade400),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        ),
      ],
    );
  }
}
