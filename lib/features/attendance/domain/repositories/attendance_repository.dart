import 'package:summercamp/features/attendance/domain/entities/update_attendance.dart';

abstract class AttendanceRepository {
  Future<void> updateAttendanceList(List<UpdateAttendance> requests);
}
