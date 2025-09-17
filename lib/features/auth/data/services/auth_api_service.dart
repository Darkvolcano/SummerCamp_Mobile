import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:summercamp/core/config/constants.dart';
import 'package:summercamp/core/network/api_client.dart';
import 'package:summercamp/core/network/dio_error_mapper.dart';

class AuthApiService {
  final ApiClient client;

  AuthApiService(this.client);

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final res = await client.post(
        'auth/login',
        data: {'email': email, 'password': password},
      );

      final data = res.data as Map<String, dynamic>;

      // Save token to SharedPreferences
      if (data['token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.tokenKey, data['token']);
      }

      return data;
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
}
