import 'package:summercamp/features/report/domain/entities/report.dart';
import 'package:summercamp/features/report/domain/repositories/report_repository.dart';

class GetReports {
  final ReportRepository repository;
  GetReports(this.repository);

  Future<List<Report>> call() async {
    return await repository.getReports();
  }
}
