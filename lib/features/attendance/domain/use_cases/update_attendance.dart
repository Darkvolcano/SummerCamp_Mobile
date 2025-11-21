import 'package:summercamp/features/attendance/domain/entities/update_attendance.dart';
import 'package:summercamp/features/attendance/domain/repositories/attendance_repository.dart';

class UpdateAttendanceList {
  final AttendanceRepository repository;
  UpdateAttendanceList(this.repository);

  Future<void> call(List<UpdateAttendance> requests) {
    return repository.updateAttendanceList(requests);
  }
}
