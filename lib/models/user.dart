class User {
  final int id;
  final String fullName;
  final String email;
  final String? role;
  final String? dateOfBirth;
  final String? gender;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    this.role,
    this.dateOfBirth,
    this.gender,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['full_name'],
      email: json['email'],
      role: json['role'],
      dateOfBirth: json['date_of_birth'],
      gender: json['gender'],
    );
  }
}
