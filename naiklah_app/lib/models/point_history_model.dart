/// Model for point transaction history
class PointHistoryModel {
  final String id;
  final String title;
  final int points;
  final bool isDeduction;
  final DateTime timestamp;

  PointHistoryModel({
    required this.id,
    required this.title,
    required this.points,
    required this.isDeduction,
    required this.timestamp,
  });

  String get formattedPoints => isDeduction ? '-$points' : '+$points';
}
