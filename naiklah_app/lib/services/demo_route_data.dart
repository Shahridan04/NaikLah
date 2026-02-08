import 'package:latlong2/latlong.dart';

/// Mock data for the bus route demonstration
class DemoRouteData {
  /// The "Safe Path" - Main road (Jalan Tun Perak -> Jalan Pudu)
  static const List<LatLng> safeRoute = [
    LatLng(3.147271, 101.699533), // Start: Masjid Jamek
    LatLng(3.146608, 101.695843), // Merdeka Square
    LatLng(3.145239, 101.694685), // Dayabumi
    LatLng(3.142861, 101.696680), // Pasar Seni
    LatLng(3.140483, 101.698998), // Chinatown
    LatLng(3.138855, 101.701315), // Pudu Sentral (End)
  ];

  /// The "Deviation Path" - Turns into a dark alley/side street
  /// Deviates after point index 2 (Dayabumi)
  static const List<LatLng> deviationPath = [
    LatLng(3.147271, 101.699533), // Start
    LatLng(3.146608, 101.695843), // Merdeka Square
    LatLng(3.145239, 101.694685), // Dayabumi (Last safe point)
    // DEVIATION STARTS HERE
    LatLng(3.145800, 101.693000), // Weird turn left
    LatLng(3.146500, 101.691500), // Going off main road
    LatLng(3.147500, 101.690500), // Into unknown area
  ];

  /// Returns interpolated points for smooth animation
  /// Generates ~10 steps between each major waypoint
  static List<LatLng> getSimulationPoints({bool isSafe = true}) {
    final List<LatLng> mainPoints = isSafe ? safeRoute : deviationPath;
    final List<LatLng> smoothPoints = [];

    for (int i = 0; i < mainPoints.length - 1; i++) {
      final start = mainPoints[i];
      final end = mainPoints[i + 1];

      // Add start point
      smoothPoints.add(start);

      // Add 10 interpolated steps
      const int steps = 10;
      for (int step = 1; step < steps; step++) {
        final double t = step / steps;
        final double lat = start.latitude + (end.latitude - start.latitude) * t;
        final double lng =
            start.longitude + (end.longitude - start.longitude) * t;
        smoothPoints.add(LatLng(lat, lng));
      }
    }
    // Add final point
    smoothPoints.add(mainPoints.last);

    return smoothPoints;
  }
}
