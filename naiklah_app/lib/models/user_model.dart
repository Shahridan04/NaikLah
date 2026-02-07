/// User model with gender-based preferences
class UserModel {
  final String id;
  final String name;
  final String email;
  final String gender; // 'male' or 'female'
  final String? company;
  final List<String> preferredTransport;
  final bool prefersWomenOnlyTransport;
  final int points;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.gender,
    this.company,
    this.preferredTransport = const [],
    this.prefersWomenOnlyTransport = false,
    this.points = 0,
  });

  /// Check if user is female (can see Pink Bus options)
  bool get isFemale => gender.toLowerCase() == 'female';

  /// Check if user is male
  bool get isMale => gender.toLowerCase() == 'male';

  /// Can this user see Women-Only transport options?
  bool get canSeeWomenOnlyOptions => isFemale;

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? gender,
    String? company,
    List<String>? preferredTransport,
    bool? prefersWomenOnlyTransport,
    int? points,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      company: company ?? this.company,
      preferredTransport: preferredTransport ?? this.preferredTransport,
      prefersWomenOnlyTransport:
          prefersWomenOnlyTransport ?? this.prefersWomenOnlyTransport,
      points: points ?? this.points,
    );
  }
}
