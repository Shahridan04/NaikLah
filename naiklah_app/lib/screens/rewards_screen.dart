import 'package:flutter/material.dart';
import '../models/reward_model.dart';
import '../services/rewards_data_service.dart';

/// Rewards Screen - Based on Figma design
/// Shows points balance, featured rewards, all rewards grid, and redemption history
class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  // Brand colors
  static const Color emeraldGreen = Color(0xFF10B981);
  static const Color hotPink = Color(0xFFEC4899);
  static const Color deepPurple = Color(0xFF8B5CF6);
  static const Color brightBlue = Color(0xFF3B82F6);

  late UserPointsModel userPoints;
  late List<RewardModel> featuredRewards;
  late List<RewardModel> allRewards;
  late List<RedemptionModel> recentRedemptions;

  @override
  void initState() {
    super.initState();
    userPoints = RewardsDataService.getUserPoints();
    featuredRewards = RewardsDataService.getFeaturedRewards();
    allRewards = RewardsDataService.getAllRewards();
    recentRedemptions = RewardsDataService.getRecentRedemptions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Gradient Header with Points
          _buildGradientHeader(),
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Featured Rewards
                  _buildSectionTitle('Featured Rewards'),
                  const SizedBox(height: 12),
                  _buildFeaturedRewards(),
                  const SizedBox(height: 24),
                  // All Rewards
                  _buildSectionTitle('All Rewards'),
                  const SizedBox(height: 12),
                  _buildAllRewardsGrid(),
                  const SizedBox(height: 24),
                  // Recent Redemptions
                  _buildRecentRedemptions(),
                  const SizedBox(height: 24),
                  // Coming Soon Banner
                  _buildComingSoonBanner(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Gradient Header with Points Balance
  Widget _buildGradientHeader() {
    return SliverToBoxAdapter(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [hotPink, deepPurple],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rewards',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Redeem your points for exciting rewards',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Points Balance Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        emeraldGreen,
                        emeraldGreen.withValues(alpha: 0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Points Balance',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${userPoints.currentPoints}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Icon(Icons.star, color: Colors.amber, size: 48),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  /// Featured Rewards (horizontal cards)
  Widget _buildFeaturedRewards() {
    return SizedBox(
      height: 200, // Increased from 180 to fix overflow
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: featuredRewards.length,
        itemBuilder: (context, index) {
          final reward = featuredRewards[index];
          final isGreen = index == 0;
          return _buildFeaturedRewardCard(reward, isGreen);
        },
      ),
    );
  }

  Widget _buildFeaturedRewardCard(RewardModel reward, bool isGreen) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isGreen
              ? [emeraldGreen, const Color(0xFF059669)]
              : [brightBlue, const Color(0xFF1D4ED8)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon and Featured badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _getRewardIcon(reward.iconType, Colors.white, 32),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Featured',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          // Title
          Text(
            reward.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            reward.description,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 12,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          // Points and Redeem
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${reward.points}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'points',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () => _redeemReward(reward),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: isGreen ? emeraldGreen : brightBlue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Redeem'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// All Rewards Grid
  Widget _buildAllRewardsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.55, // Further reduced to fix 9.2px overflow
      ),
      itemCount: allRewards.length,
      itemBuilder: (context, index) {
        return _buildRewardCard(allRewards[index]);
      },
    );
  }

  Widget _buildRewardCard(RewardModel reward) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon and wishlist
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _getRewardIcon(
                reward.iconType,
                _getCategoryColor(reward.category),
                36,
              ),
              Icon(
                Icons.bookmark_border,
                color: Colors.grey.shade400,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Category
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              reward.category,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Title
          Text(
            reward.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          // Description
          Text(
            reward.description,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          // Points and availability
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${reward.points}',
                    style: TextStyle(
                      color: _getCategoryColor(reward.category),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'points',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 10),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${reward.availableCount} left',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                  ),
                  Text(
                    'available',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Redeem button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _redeemReward(reward),
              style: ElevatedButton.styleFrom(
                backgroundColor: hotPink,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Redeem',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Recent Redemptions Section
  Widget _buildRecentRedemptions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Redemptions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          ...recentRedemptions.map(
            (redemption) => _buildRedemptionItem(redemption),
          ),
        ],
      ),
    );
  }

  Widget _buildRedemptionItem(RedemptionModel redemption) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: deepPurple.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.card_giftcard, color: deepPurple, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  redemption.rewardName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  redemption.timeAgo,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Text(
            '-${redemption.pointsUsed} pts',
            style: const TextStyle(
              color: hotPink,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  /// Coming Soon Banner
  Widget _buildComingSoonBanner() {
    final partners = RewardsDataService.getUpcomingPartners();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [brightBlue, deepPurple],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text(
            'More Rewards Coming Soon!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'We\'re partnering with more businesses to bring you even better rewards',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: partners.map((partner) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  partner,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// Helper: Get reward icon
  Widget _getRewardIcon(String iconType, Color color, double size) {
    IconData iconData;
    switch (iconType) {
      case 'coffee':
        iconData = Icons.coffee;
        break;
      case 'bus':
        iconData = Icons.directions_bus;
        break;
      case 'shopping':
        iconData = Icons.shopping_bag;
        break;
      case 'cinema':
        iconData = Icons.movie;
        break;
      case 'gym':
        iconData = Icons.fitness_center;
        break;
      case 'book':
        iconData = Icons.menu_book;
        break;
      case 'grab':
        iconData = Icons.local_taxi;
        break;
      default:
        iconData = Icons.card_giftcard;
    }
    return Icon(iconData, color: color, size: size);
  }

  /// Helper: Get category color
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Food & Beverage':
        return Colors.orange;
      case 'Transport':
        return hotPink;
      case 'Shopping':
        return brightBlue;
      case 'Entertainment':
        return deepPurple;
      case 'Health':
        return Colors.amber;
      case 'Education':
        return emeraldGreen;
      default:
        return Colors.grey;
    }
  }

  /// Redeem reward action
  void _redeemReward(RewardModel reward) {
    if (userPoints.currentPoints >= reward.points) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Confirm Redemption'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _getRewardIcon(reward.iconType, hotPink, 48),
              const SizedBox(height: 16),
              Text(
                reward.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text('${reward.points} points will be deducted'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showRedemptionSuccess(reward);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: hotPink,
                foregroundColor: Colors.white,
              ),
              child: const Text('Confirm'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not enough points for this reward'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showRedemptionSuccess(RewardModel reward) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: emeraldGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: emeraldGreen,
                size: 64,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Redemption Successful! 🎉',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 8),
            Text(
              'You\'ve redeemed ${reward.name}',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              '-${reward.points} points',
              style: const TextStyle(
                color: hotPink,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: emeraldGreen,
                foregroundColor: Colors.white,
              ),
              child: const Text('Great!'),
            ),
          ),
        ],
      ),
    );
  }
}
