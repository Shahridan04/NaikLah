/// Model for reward items in NaikLah Eco-Rewards system
class RewardModel {
  final String id;
  final String name;
  final String description;
  final int points;
  final int availableCount;
  final String category;
  final String
  iconType; // 'coffee', 'bus', 'shopping', 'cinema', 'gym', 'book', 'grab'
  final bool isFeatured;

  const RewardModel({
    required this.id,
    required this.name,
    required this.description,
    required this.points,
    required this.availableCount,
    required this.category,
    required this.iconType,
    this.isFeatured = false,
  });
}

/// Model for redemption history
class RedemptionModel {
  final String id;
  final String rewardName;
  final int pointsUsed;
  final DateTime redeemedAt;

  const RedemptionModel({
    required this.id,
    required this.rewardName,
    required this.pointsUsed,
    required this.redeemedAt,
  });

  String get timeAgo {
    final difference = DateTime.now().difference(redeemedAt);
    if (difference.inDays > 7) {
      return '${(difference.inDays / 7).floor()} week${difference.inDays > 14 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}

/// User points and tier info
class UserPointsModel {
  final int currentPoints;
  final String tier; // Bronze, Silver, Gold, Platinum
  final int totalTrips;
  final double totalCO2Saved;

  const UserPointsModel({
    required this.currentPoints,
    required this.tier,
    required this.totalTrips,
    required this.totalCO2Saved,
  });
}
