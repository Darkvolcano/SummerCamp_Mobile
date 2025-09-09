import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config/constants.dart';
import 'api_interceptor.dart';

class ApiClient {
  final Dio _dio;

  ApiClient()
    : _dio = Dio(
        BaseOptions(
          baseUrl: AppConstants.apiBaseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {"Content-Type": "application/json"},
        ),
      ) {
    _dio.interceptors.add(ApiInterceptor()); // ✅ Gắn token interceptor
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }
  }

  // Hàm gọi API
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.get(path, queryParameters: queryParameters, options: options);
  }

  Future<Response> post(String path, {dynamic data, Options? options}) {
    return _dio.post(path, data: data, options: options);
  }

  Future<Response> put(String path, {dynamic data, Options? options}) {
    return _dio.put(path, data: data, options: options);
  }

  Future<Response> delete(String path, {dynamic data, Options? options}) {
    return _dio.delete(path, data: data, options: options);
  }

  Dio get dio => _dio;
}
