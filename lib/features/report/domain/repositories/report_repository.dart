import 'package:summercamp/features/report/domain/entities/report.dart';

abstract class ReportRepository {
  Future<List<Report>> getReports();
  Future<Map<String, dynamic>> createReport({
    required int campId,
    required int camperId,
    required String note,
    required int activityScheduleId,
    required int level,
    required String imageUrl,
  });
  Future<Map<String, dynamic>> createTransportReport({
    required int campId,
    required int camperId,
    required int transportScheduleId,
    required String note,
    required String imageUrl,
  });
}
