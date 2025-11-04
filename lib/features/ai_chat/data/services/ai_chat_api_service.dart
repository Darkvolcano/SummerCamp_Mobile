import 'package:dio/dio.dart';
import 'package:summercamp/core/network/api_client.dart';
import 'package:summercamp/core/network/dio_error_mapper.dart';

class AIChatApiService {
  final ApiClient client;
  AIChatApiService(this.client);

  Future<Map<String, dynamic>> sendMessage({
    required Map<String, dynamic> data,
  }) async {
    try {
      final res = await client.post('chat', data: data);
      return res.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }
}
