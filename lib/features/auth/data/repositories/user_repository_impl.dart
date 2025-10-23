import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:summercamp/core/config/constants.dart';
import 'package:summercamp/features/auth/data/models/user_model.dart';
import 'package:summercamp/features/auth/data/services/auth_api_service.dart';
import 'package:summercamp/features/auth/domain/entities/user.dart';
import 'package:summercamp/features/auth/domain/repositories/user_repository.dart';
import 'package:summercamp/features/auth/domain/use_cases/register_response.dart';

class UserRepositoryImpl implements UserRepository {
  final AuthApiService service;
  UserRepositoryImpl(this.service);

  User _parseUser(Map<String, dynamic> data) {
    final raw = (data['user'] is Map<String, dynamic>) ? data['user'] : data;

    final processedData = Map<String, dynamic>.from(raw);

    if (processedData['name'] == null) {
      processedData['name'] = '';
    }
    if (processedData['email'] == null) {
      processedData['email'] = '';
    }
    if (processedData['role'] == null) {
      processedData['role'] = '';
    }

    return UserModel.fromJson(processedData);
  }

  @override
  Future<User> login(String email, String password) async {
    final token = await service.login(email, password);

    if (token == null) {
      throw Exception('Login failed: No token received');
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.tokenKey, token);

    final userJson = prefs.getString(AppConstants.userKey);
    if (userJson == null) {
      throw Exception('Login failed: Missing user data from token');
    }

    final Map<String, dynamic> userMap = jsonDecode(userJson);
    final user = _parseUser(userMap);

    return user;
  }

  @override
  Future<RegisterResponse> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String password,
    required String dob,
  }) async {
    final data = await service.register(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
      password: password,
      dob: dob,
    );

    return RegisterResponse.fromJson(data);
  }

  @override
  Future<User> verifyOTP({required String email, required String otp}) async {
    final data = await service.verifyOTP(email: email, otp: otp);

    return _parseUser(data);
  }

  @override
  Future<User> getUserProfile(String userId) async {
    final data = await service.getUserProfile(userId);
    return _parseUser(data);
  }

  @override
  Future<User> getUserProfiles() async {
    final data = await service.getUserProfiles();
    return _parseUser(data);
  }

  @override
  Future<List<User>> getUsers() async {
    final list = await service.fetchUsers();
    return list.map((e) => UserModel.fromJson(e)).toList();
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.tokenKey);
    await prefs.remove(AppConstants.userKey);
  }

  @override
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.tokenKey);
  }

  @override
  Future<String> forgotPassword(String email) async {
    final data = await service.forgotPassword(email);
    if (data.containsKey('message')) {
      return data['message'] as String;
    }
    throw Exception('Forgot password failed: Invalid response from server');
  }

  @override
  Future<String> resetPassword(
    String email,
    String otp,
    String newPassword,
  ) async {
    final data = await service.resetPassword(email, otp, newPassword);
    if (data.containsKey('message')) {
      return data['message'] as String;
    }
    throw Exception('Reset password failed: Invalid response from server');
  }

  @override
  Future<void> resendOtp({required String email}) async {
    return await service.resendOtp(email: email);
  }
}
