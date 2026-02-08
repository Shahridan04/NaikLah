import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import 'points_history_screen.dart';

/// Premium Rewards Screen - "Sophisticated & Trustworthy"
class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen>
    with TickerProviderStateMixin {
  // Premium Palette
  static const Color bgSoftPurple = Color(0xFFF5F3FF); // Violet 50
  static const Color darkPlatinum = Color(0xFF1E293B); // Slate 800
  static const Color textDark = Color(0xFF0F172A); // Slate 900
  static const Color textGrey = Color(0xFF64748B); // Slate 500
  static const Color accentPurple = Color(0xFF7C3AED); // Violet 600

  late AnimationController _pointsController;
  late Animation<int> _pointsAnimation;

  // Brand Rewards Data
  final List<BrandReward> _rewards = [
    BrandReward(
      brand: 'Grab',
      logoUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a1/Grab_logo.svg/200px-Grab_logo.svg.png',
      points: 500,
      reward: 'RM5 Ride Voucher',
      tagline: 'Reliable rides for less.',
      color: const Color(0xFF00B14F),
    ),
    BrandReward(
      brand: "Touch 'n Go",
      logoUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/3/33/Touch_%27n_Go_eWallet_logo.svg/200px-Touch_%27n_Go_eWallet_logo.svg.png',
      points: 300,
      reward: 'RM3 eWallet Credit',
      tagline: 'Cashless made easy.',
      color: const Color(0xFF005EB8),
    ),
    BrandReward(
      brand: 'Starbucks',
      logoUrl:
          'https://upload.wikimedia.org/wikipedia/en/thumb/d/d3/Starbucks_Corporation_Logo_2011.svg/200px-Starbucks_Corporation_Logo_2011.svg.png',
      points: 800,
      reward: 'Free Tall Drink',
      tagline: 'Your perfect brew.',
      color: const Color(0xFF00704A),
    ),
    BrandReward(
      brand: "McDonald's",
      logoUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/3/36/McDonald%27s_Golden_Arches.svg/200px-McDonald%27s_Golden_Arches.svg.png',
      points: 400,
      reward: 'McValue Meal',
      tagline: 'Favorites you love.',
      color: const Color(0xFFFFC72C),
    ),
    BrandReward(
      brand: 'Shopee',
      logoUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0e/Shopee_logo.svg/200px-Shopee_logo.svg.png',
      points: 600,
      reward: 'RM8 Voucher',
      tagline: 'Shop online instantly.',
      color: const Color(0xFFEE4D2D),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pointsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Animate points on load
    final user = UserService().currentUser;
    final targetPoints = user?.points ?? 0;
    _pointsAnimation = IntTween(begin: 0, end: targetPoints).animate(
      CurvedAnimation(parent: _pointsController, curve: Curves.easeOutCubic),
    );

    _pointsController.forward();
  }

  @override
  void dispose() {
    _pointsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgSoftPurple,
      body: ValueListenableBuilder<UserModel?>(
        valueListenable: UserService().currentUserNotifier,
        builder: (context, user, child) {
          return SafeArea(
            bottom: false,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 24.0,
                    ),
                    child: _buildHeader(user),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 32),
                        _buildPointsCardContent(user),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: _buildSectionTitle('Available Rewards'),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  sliver: _buildRewardsList(user?.points ?? 0),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 40)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(UserModel? user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // FIX: Expanded to prevent overflow
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Rewards',
                style: TextStyle(
                  color: textDark,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Exclusive benefits for you',
                style: TextStyle(color: textGrey, fontSize: 16),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        _buildHistoryButton(),
      ],
    );
  }

  Widget _buildHistoryButton() {
    return Material(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PointsHistoryScreen()),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Icon(Icons.history, color: textDark),
        ),
      ),
    );
  }

  Widget _buildPointsCardContent(UserModel? user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: darkPlatinum,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: darkPlatinum.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TOTAL BALANCE',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  AnimatedBuilder(
                    animation: _pointsAnimation,
                    builder: (context, child) {
                      return Text(
                        '${_pointsAnimation.value}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -1,
                        ),
                      );
                    },
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.star_rounded,
                  color: Color(0xFFFFD700), // Gold star
                  size: 32,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              // Premium Member Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.verified_user,
                      color: Colors.white.withOpacity(0.9),
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Platinum Member',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: textDark,
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _buildRewardsList(int currentPoints) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final reward = _rewards[index];
        return _buildRewardItem(reward, currentPoints);
      }, childCount: _rewards.length),
    );
  }

  Widget _buildRewardItem(BrandReward reward, int currentPoints) {
    final canRedeem = currentPoints >= reward.points;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: canRedeem ? () => _confirmRedemption(reward) : null,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Brand Logo Container
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade100),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.network(
                        reward.logoUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.local_offer,
                            color: reward.color,
                            size: 24,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reward.brand,
                        style: TextStyle(
                          fontSize: 12,
                          color: textGrey,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        reward.reward,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        reward.tagline,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
                // Points & Action
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${reward.points}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: canRedeem ? accentPurple : Colors.grey.shade300,
                      ),
                    ),
                    Text(
                      'pts',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmRedemption(BrandReward reward) {
    HapticFeedback.lightImpact();

    // Using a glassmorphism style dialog
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Brand Logo
                    Container(
                      width: 80,
                      height: 80,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Image.network(
                        reward.logoUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.card_giftcard,
                          color: reward.color,
                          size: 32,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    DefaultTextStyle(
                      style: const TextStyle(
                        fontFamily: 'Roboto', // Or system default
                        inherit: false,
                        decoration: TextDecoration.none,
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Redeem Reward',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: textDark,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Are you sure you want to redeem\n${reward.reward}?',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: textGrey,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${reward.points} points will be deducted.',
                            style: TextStyle(
                              fontSize: 14,
                              color: accentPurple.withOpacity(0.8),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: textGrey, fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _processRedemption(reward);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: darkPlatinum,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Redeem',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _processRedemption(BrandReward reward) {
    // Determine success based on points
    // This connects to the real user service
    final success = UserService().deductPoints(
      reward.points,
      'Redeemed ${reward.brand}',
    );

    if (success) {
      if (!mounted) return;
      HapticFeedback.heavyImpact();

      // Update animation target
      final user = UserService().currentUser;
      final newPoints = user?.points ?? 0;
      final oldPoints = newPoints + reward.points;

      _pointsAnimation = IntTween(begin: oldPoints, end: newPoints).animate(
        CurvedAnimation(parent: _pointsController, curve: Curves.easeOutCubic),
      );
      _pointsController.forward(from: 0);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.white),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Redemption Successful',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Enjoy your ${reward.brand} reward!'),
                ],
              ),
            ],
          ),
          backgroundColor: const Color(0xFF10B981), // Emerald
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 4),
        ),
      );
    } else {
      if (!mounted) return;
      HapticFeedback.mediumImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Insufficient points to redeem this reward.'),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }
}

class BrandReward {
  final String brand;
  final String logoUrl;
  final int points;
  final String reward;
  final String tagline;
  final Color color;

  BrandReward({
    required this.brand,
    required this.logoUrl,
    required this.points,
    required this.reward,
    required this.tagline,
    required this.color,
  });
}
