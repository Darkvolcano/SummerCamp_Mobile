import 'dart:io';

import 'package:flutter/material.dart';
import 'package:summercamp/features/attendance/domain/entities/update_attendance.dart';
import 'package:summercamp/features/attendance/domain/use_cases/recognize_face.dart';
import 'package:summercamp/features/attendance/domain/use_cases/update_attendance.dart';

class AttendanceProvider with ChangeNotifier {
  final UpdateAttendanceList updateAttendanceListUseCase;
  final RecognizeFace recognizeFaceUseCase;

  AttendanceProvider(
    this.updateAttendanceListUseCase,
    this.recognizeFaceUseCase,
  );

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

  Future<Map<String, dynamic>> recognizeFace({
    required int activityScheduleId,
    required File photo,
    required int campId,
    required int groupId,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await recognizeFaceUseCase(
        activityScheduleId: activityScheduleId,
        photo: photo,
        campId: campId,
        groupId: groupId,
      );
      return result;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
