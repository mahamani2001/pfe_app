class User {
  final int id;
  final String fullName;
  final String email;
  final String role;
  final String publicKey;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.publicKey,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['full_name'],
      email: json['email'],
      role: json['role'],
      publicKey: json['public_key'] ?? '',
    );
  }
}
