import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/point_history_model.dart';
import 'mock_user_service.dart';

/// Service to manage user state (Singleton)
class UserService {
  // Private constructor
  UserService._internal();

  // Singleton instance
  static final UserService _instance = UserService._internal();

  // Factory constructor
  factory UserService() => _instance;

  // Current user (ValueNotifier for reactive UI)
  final ValueNotifier<UserModel?> currentUserNotifier =
      ValueNotifier<UserModel?>(null);

  UserModel? get currentUser => currentUserNotifier.value;

  bool get isLoggedIn => currentUser != null;

  bool get isGuardian =>
      currentUser?.id ==
      'user_guardian'; // Simple check for now based on ID or we can add a field

  // Points History
  final ValueNotifier<List<PointHistoryModel>> pointHistoryNotifier =
      ValueNotifier<List<PointHistoryModel>>([]);

  /// Deduct points from current user
  bool deductPoints(int amount, String description) {
    if (currentUser == null || currentUser!.points < amount) return false;

    final updatedPoints = currentUser!.points - amount;
    _updateUserPoints(updatedPoints);

    _addHistory(description, amount, true);
    return true;
  }

  /// Add points to current user
  void addPoints(int amount, String description) {
    if (currentUser == null) return;

    final updatedPoints = currentUser!.points + amount;
    _updateUserPoints(updatedPoints);

    _addHistory(description, amount, false);
  }

  void _updateUserPoints(int points) {
    if (currentUser != null) {
      currentUserNotifier.value = currentUser!.copyWith(points: points);
    }
  }

  void _addHistory(String title, int points, bool isDeduction) {
    final history = PointHistoryModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      points: points,
      isDeduction: isDeduction,
      timestamp: DateTime.now(),
    );

    final currentHistory = List<PointHistoryModel>.from(
      pointHistoryNotifier.value,
    );
    currentHistory.insert(0, history); // Add to top
    pointHistoryNotifier.value = currentHistory;
  }

  /// Load initial history (Mock)
  void _loadMockHistory() {
    pointHistoryNotifier.value = [
      PointHistoryModel(
        id: '1',
        title: 'Safe Trip Bonus',
        points: 50,
        isDeduction: false,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      PointHistoryModel(
        id: '2',
        title: 'Referral Bonus',
        points: 100,
        isDeduction: false,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      PointHistoryModel(
        id: '3',
        title: 'Redeemed Coffee Voucher',
        points: 500,
        isDeduction: true,
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }

  /// Login with email and password
  Future<bool> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final mockUser = MockUserService.authenticate(email, password);
    if (mockUser != null) {
      currentUserNotifier.value = UserModel(
        id: mockUser.id,
        name: mockUser.name,
        email: mockUser.email,
        gender: mockUser.gender,
        points: mockUser.points,
        isGuardian: mockUser.isGuardian,
        phoneNumber: '+60123456789', // Mock phone number
      );
      _loadMockHistory(); // Load history on login
      return true;
    }
    return false;
  }

  /// Sign up new user
  void signUp({
    required String name,
    required String email,
    required String password, // In real app, handle auth
    required String gender,
    String? company,
    List<String> preferredTransport = const [],
    bool prefersWomenOnlyTransport = false,
  }) {
    currentUserNotifier.value = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      gender: gender,
      company: company,
      preferredTransport: preferredTransport,
      prefersWomenOnlyTransport: prefersWomenOnlyTransport,
      points: 500, // Welcome bonus
      phoneNumber: '', // Default empty or collect in signup
      profilePictureUrl: null,
    );
    _addHistory('Welcome Bonus', 500, false);
  }

  /// Logout
  void logout() {
    currentUserNotifier.value = null;
    pointHistoryNotifier.value = [];
  }

  /// Update user profile
  void updateProfile(UserModel updatedUser) {
    currentUserNotifier.value = updatedUser;
    // In a real app, we would make an API call here.
  }
}
