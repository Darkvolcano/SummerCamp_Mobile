import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:summercamp/core/config/constants.dart';
import 'package:summercamp/core/network/api_client.dart';
import 'package:summercamp/core/network/dio_error_mapper.dart';

class AuthApiService {
  final ApiClient client;

  AuthApiService(this.client);

  Future<String?> login(String email, String password) async {
    try {
      final res = await client.post(
        'auth/login',
        data: {'email': email, 'password': password},
      );

      final data = res.data as Map<String, dynamic>;
      final token = data['accessToken'] as String?;

      if (token == null) {
        return null;
      }

      Map<String, dynamic> decoded = {};
      try {
        decoded = JwtDecoder.decode(token);
      } catch (e) {
        decoded = {};
      }

      final userIdRaw = decoded['sub'];
      int userId = 0;
      if (userIdRaw != null) {
        userId = int.tryParse(userIdRaw.toString()) ?? 0;
      }

      final expRaw = decoded['exp'];
      int exp = 0;
      if (expRaw != null) {
        exp = int.tryParse(expRaw.toString()) ?? 0;
      }

      final userData = {
        'userId': userId,
        'name': decoded['name'] ?? '',
        'exp': exp,
        'email': decoded['email'] ?? '',
        'role': decoded['role'] ?? '',
      };

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.tokenKey, token);
      await prefs.setString(AppConstants.userKey, jsonEncode(userData));

      if (kDebugMode) {
        print('=== LOGIN SUCCESS ===');
        print('Token: ${token.substring(0, 20)}...');
        print('User Data: $userData');
        print('Role: ${userData['role']}');
      }

      return token;
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String password,
    required String dob,
  }) async {
    try {
      final res = await client.post(
        'auth/register',
        data: {
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'phoneNumber': phoneNumber,
          'password': password,
          'dob': dob,
        },
      );
      final data = res.data as Map<String, dynamic>;

      if (data['token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.tokenKey, data['token']);
      }
      return data;
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  Future<Map<String, dynamic>> verifyOTP({
    required String email,
    required String otp,
  }) async {
    try {
      final res = await client.post(
        'auth/verify-otp',
        data: {'email': email, 'otp': otp},
      );
      final data = res.data as Map<String, dynamic>;

      return data;
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final res = await client.get('user/user');
      return res.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  Future<void> updateUserProfile(Map<String, dynamic> data) async {
    final res = await client.put('user/user', data: data);
    return res.data;
  }

  Future<List<dynamic>> fetchUsers() async {
    final res = await client.get('users');
    return res.data as List;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.tokenKey);
  }

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final res = await client.post('auth/forgot-password?email=$email');
      final data = res.data as Map<String, dynamic>;

      return data;
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  Future<Map<String, dynamic>> resetPassword(
    String email,
    String otp,
    String newPassword,
  ) async {
    try {
      final res = await client.post(
        'auth/reset-password',
        data: {'email': email, 'otp': otp, 'newPassword': newPassword},
      );
      final data = res.data as Map<String, dynamic>;

      return data;
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  Future<void> resendOtp({required String email}) async {
    try {
      await client.post('auth/resend-otp', queryParameters: {'email': email});
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }
}
