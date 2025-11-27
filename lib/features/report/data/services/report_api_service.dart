import 'package:dio/dio.dart';
import 'package:summercamp/core/network/api_client.dart';
import 'package:summercamp/core/network/dio_error_mapper.dart';

class ReportApiService {
  final ApiClient client;
  ReportApiService(this.client);

  Future<List<dynamic>> fetchReports() async {
    final res = await client.get('reports');
    return res.data as List;
  }

  Future<Map<String, dynamic>> createReport(Map<String, dynamic> data) async {
    try {
      final res = await client.post('Eeport', data: data);
      return res.data;
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }
}
