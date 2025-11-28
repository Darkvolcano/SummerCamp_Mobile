import 'package:flutter/material.dart';
import 'package:summercamp/features/schedule/domain/entities/camper_transport.dart';
import 'package:summercamp/features/schedule/domain/entities/schedule.dart';
import 'package:summercamp/features/schedule/domain/entities/transport_schedule.dart';
import 'package:summercamp/features/schedule/domain/use_cases/get_camper_transport_by_transport_schedule_id.dart';
import 'package:summercamp/features/schedule/domain/use_cases/get_driver_schedules.dart';
import 'package:summercamp/features/schedule/domain/use_cases/get_staff_schedules.dart';
import 'package:summercamp/features/schedule/domain/use_cases/update_transport_schedule_end_trip.dart';
import 'package:summercamp/features/schedule/domain/use_cases/update_transport_schedule_start_trip.dart';

class ScheduleProvider with ChangeNotifier {
  final GetStaffSchedules getStaffSchedulesUseCase;
  final UpdateTransportScheduleStartTrip
  updateTransportScheduleStartTripUseCase;
  final UpdateTransportScheduleEndTrip updateTransportScheduleEndTripUseCase;
  final GetDriverSchedules getDriverSchedulesUseCase;
  final GetCampersTransportByTransportScheduleId
  getCampersTransportByTransportScheduleIdUseCase;

  ScheduleProvider(
    this.getStaffSchedulesUseCase,
    this.updateTransportScheduleStartTripUseCase,
    this.updateTransportScheduleEndTripUseCase,
    this.getDriverSchedulesUseCase,
    this.getCampersTransportByTransportScheduleIdUseCase,
  );

  List<Schedule> _schedules = [];
  List<Schedule> get schedules => _schedules;

  List<TransportSchedule> _transportSchedules = [];
  List<TransportSchedule> get transportSchedules => _transportSchedules;

  List<CamperTransport> _campersTransport = [];
  List<CamperTransport> get campersTransport => _campersTransport;

  bool _loading = false;
  bool get loading => _loading;

  Future<void> loadStaffSchedules() async {
    _loading = true;
    notifyListeners();

    try {
      _schedules = await getStaffSchedulesUseCase();
    } catch (e) {
      print("Lỗi load lịch staff: $e");
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

  Future<void> loadDriverSchedules() async {
    _loading = true;
    notifyListeners();

    try {
      _transportSchedules = await getDriverSchedulesUseCase();
    } catch (e) {
      print("Lỗi load lịch driver: $e");
      _transportSchedules = [];
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> loadCampersTransportByTransportScheduleId(
    int transportScheduleId,
  ) async {
    _loading = true;
    notifyListeners();

    _campersTransport = await getCampersTransportByTransportScheduleIdUseCase(
      transportScheduleId,
    );

    _loading = false;
    notifyListeners();
  }
}
