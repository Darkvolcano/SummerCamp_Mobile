import 'package:summercamp/features/report/domain/repositories/report_repository.dart';

class CreateReport {
  final ReportRepository repository;
  CreateReport(this.repository);

  Future<Map<String, dynamic>> call({
    required int campId,
    required int camperId,
    required String note,
    required String status,
    required int activityId,
    required String level,
  }) async {
    return await repository.createReport(
      campId: campId,
      camperId: camperId,
      note: note,
      status: status,
      activityId: activityId,
      level: level,
    );
  }
}
