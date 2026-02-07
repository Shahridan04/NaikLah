/// Model for transport mode options
class TransportMode {
  final String id;
  final String name;
  final String description;
  final int points;
  final double co2Saved; // kg CO2
  final bool isWomenOnly;
  final String iconType; // 'bus', 'train', 'bike', 'walk', 'carpool'

  const TransportMode({
    required this.id,
    required this.name,
    required this.description,
    required this.points,
    required this.co2Saved,
    this.isWomenOnly = false,
    required this.iconType,
  });
}

/// Model for available routes
class RouteModel {
  final String id;
  final String name;
  final String type;
  final bool isWomenOnly;
  final String nextArrival;
  final double safetyRating;
  final List<String> features;

  const RouteModel({
    required this.id,
    required this.name,
    required this.type,
    required this.isWomenOnly,
    required this.nextArrival,
    required this.safetyRating,
    required this.features,
  });
}
