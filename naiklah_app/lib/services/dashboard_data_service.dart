import '../models/trip_dashboard_model.dart';

/// Dashboard Data Service - Recent Trips, Leaderboard, Achievements
class DashboardDataService {
  /// Get transport modes with points and CO2 info (matching Figma)
  static List<TransportModeInfo> getTransportModes() {
    return [
      TransportModeInfo(
        id: 'pink_bus',
        name: 'Pink Bus',
        description: 'Women-only with female drivers',
        iconName: 'directions_bus',
        pointsPerTrip: 50,
        co2PerTripKg: 0.8,
        isWomenOnly: true,
      ),
      TransportModeInfo(
        id: 'bus',
        name: 'Regular Bus',
        description: 'Public bus service',
        iconName: 'directions_bus',
        pointsPerTrip: 45,
        co2PerTripKg: 0.7,
      ),
      TransportModeInfo(
        id: 'lrt',
        name: 'LRT/Train',
        description: 'Rail transport',
        iconName: 'train',
        pointsPerTrip: 40,
        co2PerTripKg: 0.6,
      ),
      TransportModeInfo(
        id: 'bicycle',
        name: 'Bicycle',
        description: 'Zero emissions',
        iconName: 'pedal_bike',
        pointsPerTrip: 60,
        co2PerTripKg: 0,
      ),
      TransportModeInfo(
        id: 'walking',
        name: 'Walking',
        description: 'Healthiest option',
        iconName: 'directions_walk',
        pointsPerTrip: 30,
        co2PerTripKg: 0,
      ),
      TransportModeInfo(
        id: 'carpool',
        name: 'Carpool',
        description: 'Shared rides',
        iconName: 'people',
        pointsPerTrip: 35,
        co2PerTripKg: 0.4,
      ),
    ];
  }

  /// Get recent trip records
  static List<TripRecord> getRecentTrips() {
    final now = DateTime.now();
    return [
      TripRecord(
        id: 't1',
        transportMode: 'pink_bus',
        routeName: 'Pink Bus',
        timestamp: DateTime(now.year, now.month, now.day, 8, 30),
        pointsEarned: 50,
        co2Saved: 0.8,
      ),
      TripRecord(
        id: 't2',
        transportMode: 'lrt',
        routeName: 'LRT',
        timestamp: DateTime(now.year, now.month, now.day, 18, 0),
        pointsEarned: 40,
        co2Saved: 0.6,
      ),
      TripRecord(
        id: 't3',
        transportMode: 'walking',
        routeName: 'Walking',
        timestamp: now.subtract(const Duration(days: 1, hours: 12)),
        pointsEarned: 30,
        co2Saved: 0,
      ),
      TripRecord(
        id: 't4',
        transportMode: 'pink_bus',
        routeName: 'Pink Bus',
        timestamp: now.subtract(const Duration(days: 1, hours: 16)),
        pointsEarned: 50,
        co2Saved: 0.8,
      ),
    ];
  }

  /// Get leaderboard entries
  static List<LeaderboardEntry> getLeaderboard() {
    return [
      LeaderboardEntry(rank: 1, name: 'Sarah Wong', points: 2150),
      LeaderboardEntry(rank: 2, name: 'Aisha Rahman', points: 1980),
      LeaderboardEntry(rank: 3, name: 'Michelle Tan', points: 1750),
      LeaderboardEntry(rank: 4, name: 'David Lee', points: 1450),
      LeaderboardEntry(
        rank: 5,
        name: 'Shidan',
        points: 1250,
        isCurrentUser: true,
      ),
    ];
  }

  /// Get achievements/badges
  static List<Achievement> getAchievements() {
    return [
      Achievement(
        id: 'week_warrior',
        title: 'Week Warrior',
        description: '7-day streak',
        iconEmoji: '🌱',
        isEarned: true,
      ),
      Achievement(
        id: 'eco_champion',
        title: 'Eco Champion',
        description: 'Saved 10kg CO2',
        iconEmoji: '🌿',
        isEarned: true,
      ),
      Achievement(
        id: 'pink_bus_pioneer',
        title: 'Pink Bus Pioneer',
        description: 'Used pink bus 20 times',
        iconEmoji: '💗',
        isEarned: false,
        progress: 15,
        total: 20,
      ),
      Achievement(
        id: 'top_10',
        title: 'Top 10',
        description: 'Reached top 10 leaderboard',
        iconEmoji: '🏆',
        isEarned: true,
      ),
    ];
  }

  /// Get user stats
  static Map<String, dynamic> getUserStats() {
    return {
      'totalPoints': 1250,
      'totalTrips': 45,
      'co2Saved': 28.5,
      'currentStreak': 7,
    };
  }
}
