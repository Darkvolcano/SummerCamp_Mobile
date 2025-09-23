import 'package:summercamp/features/auth/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.userId,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.phoneNumber,
    required super.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role,
    };
  }
}
