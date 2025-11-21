import 'package:flutter/material.dart';
import 'package:summercamp/features/attendance/domain/entities/update_attendance.dart';
import 'package:summercamp/features/attendance/domain/use_cases/update_attendance.dart';

class AttendanceProvider with ChangeNotifier {
  final UpdateAttendanceList updateAttendanceListUseCase;

  AttendanceProvider(this.updateAttendanceListUseCase);

  bool _loading = false;
  String? _error;

  bool get loading => _loading;
  String? get error => _error;

  Future<void> submitAttendance(List<UpdateAttendance> requests) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      await updateAttendanceListUseCase(requests);
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
