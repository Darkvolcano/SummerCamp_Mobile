import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:summercamp/features/report/data/models/report_model.dart';
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

  Future<void> loadReports() async {
    _loading = true;
    notifyListeners();

    final jsonString = await rootBundle.loadString('assets/mock/reports.json');

    final List<dynamic> jsonList = json.decode(jsonString);

    _reports = jsonList.map((e) => ReportModel.fromJson(e)).toList();

    // _reports = await getReportsUseCase();

    _loading = false;
    notifyListeners();
  }

  Future<void> addReport(Report r) async {
    await createReportUseCase(r);
    _reports.add(r);
    notifyListeners();
  }
}
