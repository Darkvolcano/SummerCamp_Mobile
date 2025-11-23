import 'dart:io';

import 'package:summercamp/features/auth/domain/entities/user.dart';
import 'package:summercamp/features/auth/domain/use_cases/register_response.dart';

abstract class UserRepository {
  Future<User> login(String email, String password);
  Future<RegisterResponse> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String password,
    required String dob,
  });
  Future<User> verifyOTP({required String email, required String otp});
  Future<User> getUserProfile();
  Future<void> updateUserProfile(User user);
  Future<void> logout();
  Future<List<User>> getUsers();
  Future<String?> getToken();
  Future<String> forgotPassword(String email);
  Future<String> resetPassword(String email, String otp, String newPassword);
  Future<void> resendOtp({required String email});
  Future<Map<String, dynamic>> driverRegister({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String password,
    required String dob,
    required String licenseNumber,
    required String licenseExpiry,
    required String driverAddress,
  });
  Future<void> uploadLicense(File imageFile, String token);
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  });
}
