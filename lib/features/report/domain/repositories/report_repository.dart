import 'package:summercamp/features/report/domain/entities/report.dart';

abstract class ReportRepository {
  Future<List<Report>> getReports();
  Future<void> createReport(Report report);
}
