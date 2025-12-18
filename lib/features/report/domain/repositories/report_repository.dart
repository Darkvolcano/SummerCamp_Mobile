import 'package:summercamp/features/report/domain/entities/report.dart';

abstract class ReportRepository {
  Future<List<Report>> getReports();
  Future<Map<String, dynamic>> createReport({
    required int campId,
    required int camperId,
    required String note,
    required String status,
    required int activityId,
    required String level,
  });
}
