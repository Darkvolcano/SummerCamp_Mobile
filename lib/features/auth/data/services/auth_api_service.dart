import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/dio_error_mapper.dart';
import '../../../../core/config/constants.dart';

class AuthApiService {
  final ApiClient client;

  AuthApiService(this.client);

  /// Login không cần token
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final res = await client.post(
        'auth/login',
        data: {'email': email, 'password': password},
      );

      final data = res.data as Map<String, dynamic>;

      // ✅ Lưu token vào SharedPreferences
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

      // Backend có thể trả token ngay sau khi đăng ký
      if (data['token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.tokenKey, data['token']);
      }
      return data;
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  /// Get user profile => cần token, Interceptor sẽ tự thêm
  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    try {
      final res = await client.get('users/$userId');
      return res.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  /// Đăng xuất: xoá token
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.tokenKey);
  }
}
