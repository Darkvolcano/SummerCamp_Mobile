import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:summercamp/core/config/constants.dart';

class ApiInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.tokenKey);

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Execute error 401 (refresh token, navigate login, v.v.)
    // if (err.response?.statusCode == 401) { ... }
    return handler.next(err);
  }
}
