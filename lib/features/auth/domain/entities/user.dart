class User {
  final int? userId;
  final String firstName;
  final String lastName;
  final String? name;
  final String? email;
  final String phoneNumber;
  final String? role;
  final String? avatar;
  final String? dateOfBirth;
  final String? dob;

  const User({
    this.userId,
    required this.firstName,
    required this.lastName,
    this.name,
    this.email,
    required this.phoneNumber,
    this.role,
    this.avatar,
    this.dateOfBirth,
    this.dob,
  });
}
