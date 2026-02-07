import '../models/reward_model.dart';

/// Mock data for rewards system
class RewardsDataService {
  /// Get user points (mock)
  static UserPointsModel getUserPoints() {
    return const UserPointsModel(
      currentPoints: 1250,
      tier: 'Gold',
      totalTrips: 45,
      totalCO2Saved: 28.5,
    );
  }

  /// Get featured rewards
  static List<RewardModel> getFeaturedRewards() {
    return const [
      RewardModel(
        id: 'FR001',
        name: 'RM5 Grab Voucher',
        description: 'RM5 discount on your next Grab ride',
        points: 500,
        availableCount: 50,
        category: 'Transport',
        iconType: 'grab',
        isFeatured: true,
      ),
      RewardModel(
        id: 'FR002',
        name: 'Free Bus Ride',
        description: 'One complimentary bus ride on any route',
        points: 300,
        availableCount: 100,
        category: 'Transport',
        iconType: 'bus',
        isFeatured: true,
      ),
    ];
  }

  /// Get all available rewards
  static List<RewardModel> getAllRewards() {
    return const [
      RewardModel(
        id: 'R001',
        name: 'Starbucks Coffee',
        description: 'Free tall-sized coffee at any Starbucks outlet',
        points: 600,
        availableCount: 30,
        category: 'Food & Beverage',
        iconType: 'coffee',
      ),
      RewardModel(
        id: 'R002',
        name: 'Pink Bus Monthly Pass',
        description: 'Unlimited Pink Bus rides for one month',
        points: 1200,
        availableCount: 20,
        category: 'Transport',
        iconType: 'bus',
      ),
      RewardModel(
        id: 'R003',
        name: 'RM10 Shopping Voucher',
        description: 'RM10 off at participating retail stores',
        points: 800,
        availableCount: 40,
        category: 'Shopping',
        iconType: 'shopping',
      ),
      RewardModel(
        id: 'R004',
        name: 'Cinema Ticket',
        description: 'One movie ticket at selected cinemas',
        points: 700,
        availableCount: 25,
        category: 'Entertainment',
        iconType: 'cinema',
      ),
      RewardModel(
        id: 'R005',
        name: 'Gym Day Pass',
        description: 'Full day access to partner fitness centers',
        points: 400,
        availableCount: 35,
        category: 'Health',
        iconType: 'gym',
      ),
      RewardModel(
        id: 'R006',
        name: 'Book Voucher',
        description: 'RM15 voucher at Popular bookstore',
        points: 450,
        availableCount: 45,
        category: 'Education',
        iconType: 'book',
      ),
    ];
  }

  /// Get recent redemptions
  static List<RedemptionModel> getRecentRedemptions() {
    return [
      RedemptionModel(
        id: 'RD001',
        rewardName: 'Free Bus Ride',
        pointsUsed: 300,
        redeemedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      RedemptionModel(
        id: 'RD002',
        rewardName: 'Starbucks Coffee',
        pointsUsed: 600,
        redeemedAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
    ];
  }

  /// Partner brands coming soon
  static List<String> getUpcomingPartners() {
    return ['PKT Logistics', 'Grab', 'Starbucks', 'Popular Bookstore'];
  }
}
