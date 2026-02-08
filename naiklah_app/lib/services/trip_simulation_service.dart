import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'demo_route_data.dart';

class TripSimulationService {
  // Singleton Pattern
  static final TripSimulationService _instance =
      TripSimulationService._internal();

  factory TripSimulationService() {
    return _instance;
  }

  TripSimulationService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Timer? _simulationTimer;
  final String _tripId = 'demo_trip'; // Hardcoded for hackathon demo simplicity

  // Simulation state
  int _currentIndex = 0;
  bool _isDeviationTriggered = false;
  bool _isEmergency = false; // Add emergency flag

  /// Sets the emergency state to prevent status overwrites
  void setEmergency(bool isEmergency) {
    _isEmergency = isEmergency;
    if (_isEmergency) {
      _firestore.collection('trips').doc(_tripId).update({
        'status': 'emergency',
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    }
  }

  /// Starts the trip simulation
  /// [triggerDeviation] - If true, the bus will veer off course
  Future<void> startSimulation({bool triggerDeviation = false}) async {
    // 1. Stop any existing simulation first
    stopSimulation();

    _isDeviationTriggered = triggerDeviation;
    _isEmergency = false; // Reset emergency state
    _currentIndex = 1; // Start at 1 since 0 is set as initial position

    final route = DemoRouteData.getSimulationPoints(
      isSafe: !_isDeviationTriggered,
    );

    // Reset trip status in Firestore
    await _firestore.collection('trips').doc(_tripId).set({
      'status': 'active',
      'passengerName': 'Sarah Wong',
      'routeId': 'Route A',
      'isDeviation': false,
      'startTime': FieldValue.serverTimestamp(),
      'currentLocation': {
        'latitude': route[0].latitude,
        'longitude': route[0].longitude,
      },
    });

    // Start periodic updates (every 1 second for smoothness)
    _simulationTimer = Timer.periodic(const Duration(seconds: 1), (
      timer,
    ) async {
      // Re-fetch route in loop just in case, but usually static
      // Ideally pass it in, but this is fine for demo
      final currentRoute = DemoRouteData.getSimulationPoints(
        isSafe: !_isDeviationTriggered,
      );

      if (_currentIndex >= currentRoute.length) {
        stopSimulation();
        return;
      }

      final point = currentRoute[_currentIndex];

      // Check for deviation logic (index based on interpolated points)
      // Deviation starts after roughly 30% of the trip (index 20 with 10x steps)
      bool isDeviation = _isDeviationTriggered && _currentIndex > 25;

      // Determine status based on priority: Emergency > Deviation > Active
      String newStatus = 'active';
      if (_isEmergency) {
        newStatus = 'emergency';
      } else if (isDeviation) {
        newStatus = 'alert'; // or 'deviation'
      }

      await _firestore.collection('trips').doc(_tripId).update({
        'currentLocation': {
          'latitude': point.latitude,
          'longitude': point.longitude,
        },
        'isDeviation': isDeviation,
        'status': newStatus,
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      _currentIndex++;
    });
  }

  void stopSimulation() {
    _simulationTimer?.cancel();
    _simulationTimer = null;
    // Optional: Mark as ended if not restarting
    // _firestore.collection('trips').doc(_tripId).update({'status': 'ended'});
  }
}
