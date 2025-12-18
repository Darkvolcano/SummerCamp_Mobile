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
  Future<Map<String, dynamic>> createReport({
    required int campId,
    required int camperId,
    required String note,
    required String status,
    required int activityId,
    required String level,
  }) async {
    return await service.createReport(
      campId: campId,
      camperId: camperId,
      note: note,
      status: status,
      activityId: activityId,
      level: level,
    );
  }
}
