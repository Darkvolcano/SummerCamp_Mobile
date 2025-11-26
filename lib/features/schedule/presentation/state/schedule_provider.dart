import 'package:flutter/material.dart';
import 'package:summercamp/features/schedule/domain/entities/schedule.dart';
import 'package:summercamp/features/schedule/domain/use_cases/get_schedules.dart';
import 'package:summercamp/features/schedule/domain/use_cases/update_transport_schedule_end_trip.dart';
import 'package:summercamp/features/schedule/domain/use_cases/update_transport_schedule_start_trip.dart';

class ScheduleProvider with ChangeNotifier {
  final GetSchedules getSchedulesUseCase;
  final UpdateTransportScheduleStartTrip
  updateTransportScheduleStartTripUseCase;
  final UpdateTransportScheduleEndTrip updateTransportScheduleEndTripUseCase;

  ScheduleProvider(
    this.getSchedulesUseCase,
    this.updateTransportScheduleStartTripUseCase,
    this.updateTransportScheduleEndTripUseCase,
  );

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

  Future<void> updateTransportScheduleStartTrip(int id) async {
    _loading = true;
    notifyListeners();
    try {
      await updateTransportScheduleStartTripUseCase(id);
    } catch (e) {
      print("Lỗi start trip: $e");
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> updateTransportScheduleEndTrip(int id) async {
    _loading = true;
    notifyListeners();
    try {
      await updateTransportScheduleEndTripUseCase(id);
    } catch (e) {
      print("Lỗi end trip: $e");
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
