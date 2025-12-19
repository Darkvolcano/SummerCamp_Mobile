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
    required int activityScheduleId,
    required int level,
    required String imageUrl,
  }) async {
    try {
      final res = await client.post(
        'report/incident-ticket',
        data: {
          'campId': campId,
          'camperId': camperId,
          'note': note,
          'activityScheduleId': activityScheduleId,
          'level': level,
          'imageUrl': imageUrl,
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
    required String imageUrl,
  }) async {
    try {
      final res = await client.post(
        'report/transport-incident',
        data: {
          'campId': campId,
          'camperId': camperId,
          'transportScheduleId': transportScheduleId,
          'note': note,
          'imageUrl': imageUrl,
        },
      );

      return res.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }
}
