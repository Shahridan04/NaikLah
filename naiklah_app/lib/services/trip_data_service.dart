import '../models/transport_model.dart';

/// Mock data for transport modes and routes
class TripDataService {
  /// Get available transport modes
  static List<TransportMode> getTransportModes() {
    return const [
      TransportMode(
        id: 'pink-bus',
        name: 'Pink Bus',
        description: 'Women-only with female drivers',
        points: 50,
        co2Saved: 0.8,
        isWomenOnly: true,
        iconType: 'bus',
      ),
      TransportMode(
        id: 'bus',
        name: 'Regular Bus',
        description: 'Public bus service',
        points: 45,
        co2Saved: 0.7,
        isWomenOnly: false,
        iconType: 'bus',
      ),
      TransportMode(
        id: 'train',
        name: 'LRT/Train',
        description: 'Rail transport',
        points: 40,
        co2Saved: 0.6,
        isWomenOnly: false,
        iconType: 'train',
      ),
      TransportMode(
        id: 'bicycle',
        name: 'Bicycle',
        description: 'Zero emissions',
        points: 60,
        co2Saved: 0.0,
        isWomenOnly: false,
        iconType: 'bike',
      ),
      TransportMode(
        id: 'walking',
        name: 'Walking',
        description: 'Healthiest option',
        points: 30,
        co2Saved: 0.0,
        isWomenOnly: false,
        iconType: 'walk',
      ),
      TransportMode(
        id: 'carpool',
        name: 'Carpool',
        description: 'Shared rides',
        points: 35,
        co2Saved: 0.4,
        isWomenOnly: false,
        iconType: 'carpool',
      ),
    ];
  }

  /// Get available routes near user
  static List<RouteModel> getAvailableRoutes() {
    return const [
      RouteModel(
        id: 'R001',
        name: 'Route A - City Center',
        type: 'Pink Bus',
        isWomenOnly: true,
        nextArrival: '5 mins',
        safetyRating: 4.9,
        features: ['Female Driver', 'GPS Tracked', 'CCTV', 'Emergency SOS'],
      ),
      RouteModel(
        id: 'R002',
        name: 'Route B - Industrial Park',
        type: 'Pink Bus',
        isWomenOnly: true,
        nextArrival: '12 mins',
        safetyRating: 4.8,
        features: ['Female Driver', 'GPS Tracked', 'CCTV', 'Emergency SOS'],
      ),
      RouteModel(
        id: 'R003',
        name: 'Route C - Shopping District',
        type: 'Regular Bus',
        isWomenOnly: false,
        nextArrival: '3 mins',
        safetyRating: 4.5,
        features: ['GPS Tracked', 'CCTV'],
      ),
      RouteModel(
        id: 'R004',
        name: 'LRT Blue Line',
        type: 'Train',
        isWomenOnly: false,
        nextArrival: '8 mins',
        safetyRating: 4.6,
        features: ['Women-Only Cabin Available', 'CCTV'],
      ),
    ];
  }
}
