import 'package:flutter/material.dart';
import 'package:summercamp/features/report/domain/entities/report.dart';
import 'package:summercamp/features/report/domain/use_cases/create_report.dart';
import 'package:summercamp/features/report/domain/use_cases/get_report.dart';

class ReportProvider with ChangeNotifier {
  final CreateReport createReportUseCase;
  final GetReports getReportsUseCase;

  ReportProvider(this.getReportsUseCase, this.createReportUseCase);

  List<Report> _reports = [];
  List<Report> get reports => _reports;

  bool _loading = false;
  bool get loading => _loading;
  String? _error;
  String? get error => _error;

  Future<void> loadReports() async {
    _loading = true;
    notifyListeners();

    _reports = await getReportsUseCase();

    _loading = false;
    notifyListeners();
  }

  Future<void> createReport({
    required int campId,
    required int camperId,
    required String note,
    required String status,
    required int activityId,
    required String level,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      await createReportUseCase(
        campId: campId,
        camperId: camperId,
        note: note,
        status: status,
        activityId: activityId,
        level: level,
      );
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
