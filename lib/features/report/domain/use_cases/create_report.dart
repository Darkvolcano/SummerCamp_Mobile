import 'package:summercamp/features/report/domain/entities/report.dart';
import 'package:summercamp/features/report/domain/repositories/report_repository.dart';

class CreateReport {
  final ReportRepository repository;
  CreateReport(this.repository);

  Future<void> call(Report report) {
    return repository.createReport(report);
  }
}
