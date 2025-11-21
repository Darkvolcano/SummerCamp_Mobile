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
}
