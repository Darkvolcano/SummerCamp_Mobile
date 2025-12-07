import 'dart:io';

import 'package:summercamp/features/attendance/domain/entities/update_attendance.dart';

abstract class AttendanceRepository {
  Future<void> updateAttendanceList(List<UpdateAttendance> requests);
  Future<Map<String, dynamic>> recognizeFace({
    required int activityScheduleId,
    required File photo,
    required int campId,
    required int groupId,
  });
}
