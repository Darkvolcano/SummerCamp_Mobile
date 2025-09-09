import 'package:dio/dio.dart';
import '../error/exceptions.dart';

NetworkException mapDioError(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.sendTimeout:
      return NetworkException('Kết nối mạng chậm hoặc mất kết nối.');
    case DioExceptionType.badResponse:
      final code = e.response?.statusCode;
      final msg =
          e.response?.data is Map && (e.response?.data['message'] != null)
          ? e.response?.data['message'].toString()
          : 'Lỗi máy chủ ($code).';
      return NetworkException(msg!);
    case DioExceptionType.cancel:
      return NetworkException('Yêu cầu đã bị huỷ.');
    default:
      return NetworkException('Đã xảy ra lỗi không xác định.');
  }
}
