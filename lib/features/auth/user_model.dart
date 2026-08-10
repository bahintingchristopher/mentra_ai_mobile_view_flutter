class UserModel {
  final String username;
  final String firstName;
  final String role;

  UserModel({
    required this.username,
    required this.firstName,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Support both:
    // 1. { "user": {...} }
    // 2. { "data": { "user": {...} } }

    final Map<String, dynamic> userData =
        json['data']?['user'] ??
        json['user'] ??
        json;

    return UserModel(
      username: userData['username'] ?? '',
      firstName: userData['first_name'] ?? '',
      role: (userData['role'] ?? 'learner').toString().toLowerCase(),
    );
  }
}