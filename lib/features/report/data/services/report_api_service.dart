import 'package:dio/dio.dart';
import 'package:summercamp/core/network/api_client.dart';
import 'package:summercamp/core/network/dio_error_mapper.dart';

class ReportApiService {
  final ApiClient client;
  ReportApiService(this.client);

  Future<List<dynamic>> fetchReports() async {
    final res = await client.get('report');
    return res.data as List;
  }

  Future<Map<String, dynamic>> createReport({
    required int campId,
    required int camperId,
    required String note,
    required String status,
    required int activityId,
    required String level,
  }) async {
    try {
      final res = await client.post(
        'report',
        data: {
          'campId': campId,
          'camperId': camperId,
          'status': status,
          'note': note,
          'activityId': activityId,
          'level': level,
        },
      );

      return res.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  Future<Map<String, dynamic>> createReportTransport({
    required int campId,
    required int camperId,
    required int transportScheduleId,
    required String note,
  }) async {
    try {
      final res = await client.post(
        'report/transport-incident',
        data: {
          'campId': campId,
          'camperId': camperId,
          'transportScheduleId': transportScheduleId,
          'note': note,
        },
      );

      return res.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }
}
