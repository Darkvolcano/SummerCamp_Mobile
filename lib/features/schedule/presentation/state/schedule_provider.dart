import 'package:flutter/material.dart';
import 'package:summercamp/features/schedule/domain/entities/schedule.dart';
import 'package:summercamp/features/schedule/domain/use_cases/get_schedules.dart';

class ScheduleProvider with ChangeNotifier {
  final GetSchedules getSchedulesUseCase;

  ScheduleProvider(this.getSchedulesUseCase);

  List<Schedule> _schedules = [];
  List<Schedule> get schedules => _schedules;

  bool _loading = false;
  bool get loading => _loading;

  Future<void> loadSchedules() async {
    _loading = true;
    notifyListeners();

    try {
      _schedules = await getSchedulesUseCase();
    } catch (e) {
      print("Lỗi load lịch: $e");
      _schedules = [];
    }

    _loading = false;
    notifyListeners();
  }
}
