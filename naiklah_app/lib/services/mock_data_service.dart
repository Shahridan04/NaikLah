import '../models/bus_model.dart';

/// Mock data service for NaikLah MVP
/// Provides dummy bus data around Kuala Lumpur for demo purposes
class MockDataService {
  /// Kuala Lumpur city center coordinates
  static const double klCenterLat = 3.1390;
  static const double klCenterLng = 101.6869;

  /// Get list of buses near Kuala Lumpur
  /// Returns 5 buses: 2 Pink Buses (women-only) and 3 regular buses
  static List<BusModel> getBuses() {
    return [
      // Pink Buses (Women-Only)
      const BusModel(
        id: 'PB001',
        routeName: 'Pink Express - KLCC',
        isPink: true,
        driverGender: 'Female',
        lat: 3.1577, // Near KLCC
        lng: 101.7122,
        safetyRating: 4.9,
        nextArrival: '5 mins',
        features: ['Female Driver', 'GPS Tracked', 'CCTV', 'Emergency SOS'],
      ),
      const BusModel(
        id: 'PB002',
        routeName: 'Pink Express - Pavilion',
        isPink: true,
        driverGender: 'Female',
        lat: 3.1488, // Near Pavilion KL
        lng: 101.7133,
        safetyRating: 4.8,
        nextArrival: '8 mins',
        features: ['Female Driver', 'GPS Tracked', 'CCTV', 'Emergency SOS'],
      ),
      // Regular Buses (RapidKL)
      const BusModel(
        id: 'RK300-A',
        routeName: 'RapidKL 300 - KL Sentral',
        isPink: false,
        driverGender: 'Male',
        lat: 3.1332, // Near KL Sentral
        lng: 101.6865,
        safetyRating: 4.5,
        nextArrival: '3 mins',
        features: ['GPS Tracked', 'CCTV'],
      ),
      const BusModel(
        id: 'RK300-B',
        routeName: 'RapidKL 300 - Bukit Bintang',
        isPink: false,
        driverGender: 'Male',
        lat: 3.1466, // Near Bukit Bintang
        lng: 101.7108,
        safetyRating: 4.4,
        nextArrival: '6 mins',
        features: ['GPS Tracked', 'CCTV'],
      ),
      const BusModel(
        id: 'RK300-C',
        routeName: 'RapidKL 300 - Masjid Jamek',
        isPink: false,
        driverGender: 'Male',
        lat: 3.1496, // Near Masjid Jamek
        lng: 101.6963,
        safetyRating: 4.6,
        nextArrival: '10 mins',
        features: ['GPS Tracked', 'CCTV'],
      ),
    ];
  }

  /// Get only Pink Buses (women-only)
  static List<BusModel> getPinkBuses() {
    return getBuses().where((bus) => bus.isPink).toList();
  }

  /// Get only regular buses
  static List<BusModel> getRegularBuses() {
    return getBuses().where((bus) => !bus.isPink).toList();
  }
}
