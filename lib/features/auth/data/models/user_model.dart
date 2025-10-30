import 'package:summercamp/features/auth/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.userId,
    required super.firstName,
    required super.lastName,
    super.name,
    required super.email,
    required super.phoneNumber,
    super.role,
    super.avatar,
    required super.dateOfBirth,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final fullName = json['name'] as String? ?? '';
    final parts = fullName.split(' ');

    String firstName = parts.isNotEmpty ? parts.first : '';
    String lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    return UserModel(
      userId: json['userId'] as int? ?? 0,

      firstName: json['firstName'] as String? ?? firstName,
      lastName: json['lastName'] as String? ?? lastName,

      name: json['name'] as String? ?? '',

      phoneNumber: json['phoneNumber'] as String? ?? '',
      avatar: json['avatar'] as String? ?? '',
      dateOfBirth: json['dateOfBirth'] as String? ?? '',

      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role,
      'avatar': avatar,
      'dateOfBirth': dateOfBirth,
    };
  }
}
