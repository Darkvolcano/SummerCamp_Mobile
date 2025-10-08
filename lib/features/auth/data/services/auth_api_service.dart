import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:summercamp/core/config/constants.dart';
import 'package:summercamp/core/network/api_client.dart';
import 'package:summercamp/core/network/dio_error_mapper.dart';

class AuthApiService {
  final ApiClient client;

  AuthApiService(this.client);

  // Future<Map<String, dynamic>> login(String email, String password) async {
  //   try {
  //     final res = await client.post(
  //       'auth/login',
  //       data: {'email': email, 'password': password},
  //     );

  //     final data = res.data as Map<String, dynamic>;

  //     // Save token to SharedPreferences
  //     if (data['token'] != null) {
  //       final prefs = await SharedPreferences.getInstance();
  //       await prefs.setString(AppConstants.tokenKey, data['token']);
  //     }

  //     return data;
  //   } on DioException catch (e) {
  //     throw mapDioError(e);
  //   }
  // }
  Future<String?> login(String email, String password) async {
    try {
      final res = await client.post(
        'auth/login',
        data: {'email': email, 'password': password},
      );

      final data = res.data as Map<String, dynamic>;
      final token = data['token'];

      if (token == null) {
        return null;
      }

      // 🔹 Decode token để lấy thông tin user
      Map<String, dynamic> decoded = {};
      try {
        decoded = JwtDecoder.decode(token);
      } catch (e) {
        decoded = {};
      }

      // 🔹 Chuẩn hoá lại data user cần lưu
      final userData = {
        'userId': decoded['userId'] ?? 0,
        'firstName': decoded['firstName'] ?? '',
        'lastName': decoded['lastName'] ?? '',
        'phoneNumber': decoded['phoneNumber'] ?? '',
        'email': decoded['email'] ?? '',
        'role': decoded['role'] ?? '',
      };

      // 🔹 Lưu token & user data vào SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.tokenKey, token);
      await prefs.setString(AppConstants.userKey, jsonEncode(userData));

      // ✅ Trả về token duy nhất
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

  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    try {
      final res = await client.get('users/$userId');
      return res.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  Future<Map<String, dynamic>> getUserProfiles() async {
    try {
      final res = await client.get('users');
      return res.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw mapDioError(e);
    }
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
      final res = await client.post(
        'auth/forgot-password',
        data: {'email': email},
      );
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
}
