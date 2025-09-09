import '../../domain/entities/user.dart';

class UserModel extends User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;

  const UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
  }) : super(
         id: id,
         firstName: firstName,
         lastName: lastName,
         email: email,
         phoneNumber: phoneNumber,
       );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['userId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
    };
  }
}
