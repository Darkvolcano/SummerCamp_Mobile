import 'package:summercamp/features/attendance/domain/repositories/attendance_repository.dart';

class PreloadFaceDatabase {
  final AttendanceRepository repository;

  PreloadFaceDatabase(this.repository);

  Future<void> call(int campId, {bool forceReload = false}) {
    return repository.preloadFaceDatabase(campId, forceReload: forceReload);
  }
}
