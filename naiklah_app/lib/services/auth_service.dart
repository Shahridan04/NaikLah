import 'package:flutter/material.dart';
import '../models/user_model.dart';

/// Manages user authentication state and preferences
class AuthService extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoggedIn = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;

  /// Theme colors based on gender
  Color get primaryColor {
    if (_currentUser?.isMale == true) {
      return const Color(0xFF3B82F6); // Blue for men
    }
    return const Color(0xFFEC4899); // Hot Pink for women
  }

  Color get secondaryColor {
    if (_currentUser?.isMale == true) {
      return const Color(0xFF1D4ED8); // Darker blue
    }
    return const Color(0xFFF472B6); // Lighter pink
  }

  /// Common brand color (stays green for eco-theme)
  static const Color brandGreen = Color(0xFF10B981);

  /// Can current user see Women-Only options?
  bool get canSeeWomenOnlyOptions =>
      _currentUser?.canSeeWomenOnlyOptions ?? false;

  /// Sign up new user
  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
    required String gender,
    String? company,
    List<String> preferredTransport = const [],
    bool prefersWomenOnlyTransport = false,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    _currentUser = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      gender: gender,
      company: company,
      preferredTransport: preferredTransport,
      prefersWomenOnlyTransport: prefersWomenOnlyTransport,
      points: 0,
    );
    _isLoggedIn = true;
    notifyListeners();
    return true;
  }

  /// Log in existing user
  Future<bool> login({required String email, required String password}) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Mock user - in real app this would come from backend
    _currentUser = UserModel(
      id: 'user_mock',
      name: email.split('@').first,
      email: email,
      gender: 'female', // Default to female for demo
      points: 1250,
    );
    _isLoggedIn = true;
    notifyListeners();
    return true;
  }

  /// Log out
  void logout() {
    _currentUser = null;
    _isLoggedIn = false;
    notifyListeners();
  }

  /// Update user preferences
  void updatePreferences({
    List<String>? preferredTransport,
    bool? prefersWomenOnlyTransport,
  }) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        preferredTransport: preferredTransport,
        prefersWomenOnlyTransport: prefersWomenOnlyTransport,
      );
      notifyListeners();
    }
  }
}
