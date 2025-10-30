class User {
  final int userId;
  final String firstName;
  final String lastName;
  final String? name;
  final String email;
  final String phoneNumber;
  final String? role;
  final String? avatar;
  final String dateOfBirth;

  const User({
    required this.userId,
    required this.firstName,
    required this.lastName,
    this.name,
    required this.email,
    required this.phoneNumber,
    this.role,
    this.avatar,
    required this.dateOfBirth,
  });
}
