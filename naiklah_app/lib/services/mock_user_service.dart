/// Mock User Data Service
/// Provides pre-configured male, female, and guardian users for testing

class MockUser {
  final String id;
  final String email;
  final String password;
  final String name;
  final String gender; // 'male' or 'female'
  final int points;
  final bool isGuardian; // New field for guardian role

  const MockUser({
    required this.id,
    required this.email,
    required this.password,
    required this.name,
    required this.gender,
    required this.points,
    this.isGuardian = false,
  });

  bool get isFemale => gender == 'female';
  bool get isMale => gender == 'male';
}

class MockUserService {
  static const List<MockUser> users = [
    MockUser(
      id: 'user_female',
      email: 'sarah@test.com',
      password: '123456',
      name: 'Sarah Wong',
      gender: 'female',
      points: 1250,
    ),
    MockUser(
      id: 'user_male',
      email: 'david@test.com',
      password: '123456',
      name: 'David Lee',
      gender: 'male',
      points: 1450,
    ),
    MockUser(
      id: 'user_guardian',
      email: 'mom@test.com',
      password: '123456',
      name: 'Madam Wong (Mom)',
      gender: 'female',
      points: 500,
      isGuardian: true,
    ),
  ];

  /// Get female test user
  static MockUser get femaleUser => users[0];

  /// Get male test user
  static MockUser get maleUser => users[1];

  /// Get guardian test user
  static MockUser get guardianUser => users[2];

  /// Authenticate user by email/password
  static MockUser? authenticate(String email, String password) {
    try {
      return users.firstWhere(
        (u) =>
            u.email.toLowerCase() == email.toLowerCase() &&
            u.password == password,
      );
    } catch (_) {
      return null;
    }
  }

  /// Get user by email
  static MockUser? getByEmail(String email) {
    try {
      return users.firstWhere(
        (u) => u.email.toLowerCase() == email.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }
}
