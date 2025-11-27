import 'package:summercamp/features/report/data/models/report_model.dart';
import 'package:summercamp/features/report/data/services/report_api_service.dart';
import 'package:summercamp/features/report/domain/entities/report.dart';
import 'package:summercamp/features/report/domain/repositories/report_repository.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportApiService service;

  ReportRepositoryImpl(this.service);

  @override
  Future<List<Report>> getReports() async {
    final list = await service.fetchReports();
    return list.map((e) => ReportModel.fromJson(e)).toList();
  }

  @override
  Future<void> createReport(Report report) async {
    final model = ReportModel(
      reportId: report.reportId,
      camperId: report.camperId,
      note: report.note,
      image: report.image,
      status: report.status,
      level: report.level,
      activityId: report.activityId,
    );
    await service.createReport(model.toJson());
  }
}
