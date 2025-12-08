import 'dart:io';

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

  Future<Map<String, dynamic>> recognizeFace({
    required int activityScheduleId,
    required File photo,
    required int campId,
    required int groupId,
  }) async {
    try {
      String fileName = photo.path.split('/').last;

      FormData formData = FormData.fromMap({
        "activityScheduleId": activityScheduleId,
        "photo": await MultipartFile.fromFile(photo.path, filename: fileName),
        "campId": campId,
        "groupId": groupId,
      });

      final response = await client.post(
        'admin/ai/recognize',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  Future<void> preloadFaceDatabase(
    int campId, {
    bool forceReload = false,
  }) async {
    try {
      await client.post('admin/ai/preload/$campId?forceReload=false');
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }
}
