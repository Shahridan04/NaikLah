/// Trip Dashboard Models - Recent Trips, Leaderboard, Achievements

/// Model for a logged trip record
class TripRecord {
  final String id;
  final String
  transportMode; // 'pink_bus', 'bus', 'lrt', 'bicycle', 'walking', 'carpool'
  final String routeName;
  final DateTime timestamp;
  final int pointsEarned;
  final double co2Saved; // in kg
  final Duration duration;
  final double distance; // in km
  final int routeDeviation;
  final int stops;

  TripRecord({
    required this.id,
    required this.transportMode,
    required this.routeName,
    required this.timestamp,
    required this.pointsEarned,
    required this.co2Saved,
    required this.duration,
    required this.distance,
    required this.routeDeviation,
    required this.stops,
  });

  String get formattedTime {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final tripDate = DateTime(timestamp.year, timestamp.month, timestamp.day);

    String dateStr;
    if (tripDate == today) {
      dateStr = 'Today';
    } else if (tripDate == yesterday) {
      dateStr = 'Yesterday';
    } else {
      dateStr = '${timestamp.day}/${timestamp.month}';
    }

    final hour = timestamp.hour > 12 ? timestamp.hour - 12 : timestamp.hour;
    final period = timestamp.hour >= 12 ? 'PM' : 'AM';
    final min = timestamp.minute.toString().padLeft(2, '0');
    return '$dateStr, $hour:$min $period';
  }
}

/// Model for leaderboard entry
class LeaderboardEntry {
  final int rank;
  final String name;
  final int points;
  final bool isCurrentUser;

  LeaderboardEntry({
    required this.rank,
    required this.name,
    required this.points,
    this.isCurrentUser = false,
  });
}

/// Model for achievements/badges
class Achievement {
  final String id;
  final String title;
  final String description;
  final String iconEmoji;
  final bool isEarned;
  final int? progress; // null if earned, otherwise progress percentage
  final int? total; // total needed to earn

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.iconEmoji,
    required this.isEarned,
    this.progress,
    this.total,
  });
}

/// Extended transport mode with points and CO2 info
class TransportModeInfo {
  final String id;
  final String name;
  final String description;
  final String iconName;
  final int pointsPerTrip;
  final double co2PerTripKg;
  final bool isWomenOnly;

  TransportModeInfo({
    required this.id,
    required this.name,
    required this.description,
    required this.iconName,
    required this.pointsPerTrip,
    required this.co2PerTripKg,
    this.isWomenOnly = false,
  });
}
