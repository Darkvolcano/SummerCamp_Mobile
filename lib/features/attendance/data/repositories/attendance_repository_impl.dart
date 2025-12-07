import 'dart:io';

import 'package:summercamp/features/attendance/data/services/attendance_api_service.dart';
import 'package:summercamp/features/attendance/domain/entities/update_attendance.dart';
import 'package:summercamp/features/attendance/domain/repositories/attendance_repository.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceApiService service;
  AttendanceRepositoryImpl(this.service);

  @override
  Future<void> updateAttendanceList(List<UpdateAttendance> requests) async {
    await service.updateAttendance(requests);
  }

  @override
  Future<Map<String, dynamic>> recognizeFace({
    required int activityScheduleId,
    required File photo,
    required int campId,
    required int groupId,
  }) async {
    return await service.recognizeFace(
      activityScheduleId: activityScheduleId,
      photo: photo,
      campId: campId,
      groupId: groupId,
    );
  }
}
