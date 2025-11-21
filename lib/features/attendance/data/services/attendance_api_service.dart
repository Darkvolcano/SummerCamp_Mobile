import 'package:dio/dio.dart';
import 'package:summercamp/core/network/api_client.dart';
import 'package:summercamp/core/network/dio_error_mapper.dart';
import 'package:summercamp/features/attendance/domain/entities/update_attendance.dart';

class AttendanceApiService {
  final ApiClient client;
  AttendanceApiService(this.client);

  Future<void> updateAttendance(List<UpdateAttendance> requests) async {
    try {
      final data = requests.map((e) => e.toJson()).toList();

      await client.put('AttendanceLog', data: data);
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }
}
