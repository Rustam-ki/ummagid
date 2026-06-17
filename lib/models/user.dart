// lib/models/user.dart
class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String role; // 'client' | 'guide' | 'admin'
  final int? guideId; // id записи гида, если пользователь — гид
  final String? createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.role = 'client',
    this.guideId,
    this.createdAt,
  });

  bool get isGuide => role == 'guide';
  bool get isAdmin => role == 'admin';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'] ?? '',
      role: json['role'] ?? 'client',
      guideId: json['guide_id'],
      createdAt: json['created_at'],
    );
  }
}
