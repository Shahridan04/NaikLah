/// Model class for bus data in NaikLah app
/// Represents both Pink Buses (women-only) and regular buses
class BusModel {
  final String id;
  final String routeName;
  final bool isPink; // true = women-only bus
  final String driverGender;
  final double lat;
  final double lng;
  final double? safetyRating;
  final String? nextArrival;
  final List<String>? features;

  const BusModel({
    required this.id,
    required this.routeName,
    required this.isPink,
    required this.driverGender,
    required this.lat,
    required this.lng,
    this.safetyRating,
    this.nextArrival,
    this.features,
  });

  /// Check if this is a women-only Pink Bus
  bool get isWomenOnly => isPink && driverGender.toLowerCase() == 'female';

  /// Get display color based on bus type
  String get displayColor => isPink ? 'pink' : 'green';

  @override
  String toString() {
    return 'BusModel(id: $id, route: $routeName, isPink: $isPink, driver: $driverGender)';
  }
}
