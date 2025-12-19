import 'package:dio/dio.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:summercamp/features/schedule/domain/entities/camper_transport.dart';
import 'package:summercamp/features/schedule/domain/entities/route.dart';
import 'package:summercamp/features/schedule/domain/entities/schedule.dart';
import 'package:summercamp/features/schedule/domain/entities/transport_schedule.dart';
import 'package:summercamp/features/schedule/domain/use_cases/get_camper_transport_by_transport_schedule_id.dart';
import 'package:summercamp/features/schedule/domain/use_cases/get_driver_schedules.dart';
import 'package:summercamp/features/schedule/domain/use_cases/get_route_stop_by_route_id.dart';
import 'package:summercamp/features/schedule/domain/use_cases/get_staff_schedules.dart';
import 'package:summercamp/features/schedule/domain/use_cases/get_staff_transport_schedule.dart';
import 'package:summercamp/features/schedule/domain/use_cases/update_camper_transport_check_in.dart';
import 'package:summercamp/features/schedule/domain/use_cases/update_camper_transport_check_out.dart';
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
  final UpdateCamperTransportAttendanceListCheckIn
  updateAttendanceCamperTransportCheckInListUseCase;
  final UpdateCamperTransportAttendanceListCheckOut
  updateAttendanceCamperTransportCheckOutListUseCase;
  final GetStaffTransportSchedule getStaffTransportSchedulesUseCase;
  final GetRouteStopByRouteId getRouteStopByRouteIdUseCase;

  ScheduleProvider(
    this.getStaffSchedulesUseCase,
    this.updateTransportScheduleStartTripUseCase,
    this.updateTransportScheduleEndTripUseCase,
    this.getDriverSchedulesUseCase,
    this.getCampersTransportByTransportScheduleIdUseCase,
    this.updateAttendanceCamperTransportCheckInListUseCase,
    this.updateAttendanceCamperTransportCheckOutListUseCase,
    this.getStaffTransportSchedulesUseCase,
    this.getRouteStopByRouteIdUseCase,
  );

  List<Schedule> _schedules = [];
  List<Schedule> get schedules => _schedules;

  List<TransportSchedule> _transportSchedules = [];
  List<TransportSchedule> get transportSchedules => _transportSchedules;

  List<TransportSchedule> _transportStaffSchedules = [];
  List<TransportSchedule> get transportStaffSchedules =>
      _transportStaffSchedules;

  List<CamperTransport> _campersTransport = [];
  List<CamperTransport> get campersTransport => _campersTransport;

  final List<Route> _routeStop = [];
  List<Route> get routeStop => _routeStop;

  final Map<int, List<Route>> _routeStopsMap = {};
  Map<int, List<Route>> get routeStopsMap => _routeStopsMap;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

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

  Future<void> submitAttendanceCamperTransportCheckIn({
    required List<int> camperTransportIds,
    String? note,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      await updateAttendanceCamperTransportCheckInListUseCase(
        camperTransportIds: camperTransportIds,
        note: note,
      );
    } catch (e) {
      String errorMessage = e.toString();

      if (e is DioException && e.response?.data != null) {
        final data = e.response?.data;
        if (data is Map<String, dynamic> && data.containsKey('message')) {
          errorMessage = data['message'];
        }
      }

      _error = errorMessage.replaceAll("Exception: ", "");

      throw _error!;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> submitAttendanceCamperTransportCheckOut({
    required List<int> camperTransportIds,
    String? note,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      await updateAttendanceCamperTransportCheckOutListUseCase(
        camperTransportIds: camperTransportIds,
        note: note,
      );
    } catch (e) {
      String errorMessage = e.toString();

      if (e is DioException && e.response?.data != null) {
        final data = e.response?.data;
        if (data is Map<String, dynamic> && data.containsKey('message')) {
          errorMessage = data['message'];
        }
      }

      _error = errorMessage.replaceAll("Exception: ", "");

      throw _error!;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> loadStaffTransportSchedules() async {
    _loading = true;
    notifyListeners();

    try {
      _transportStaffSchedules = await getStaffTransportSchedulesUseCase();
    } catch (e) {
      print("Lỗi load lịch đưa đón staff: $e");
      _transportStaffSchedules = [];
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> loadRouteStopByRouteId(int routeId) async {
    if (_routeStopsMap.containsKey(routeId)) return;

    try {
      final stops = await getRouteStopByRouteIdUseCase(routeId);

      stops.sort((a, b) => a.stopOrder.compareTo(b.stopOrder));

      _routeStopsMap[routeId] = stops;
    } catch (e) {
      print("Lỗi load route stop cho route $routeId: $e");
    }

    notifyListeners();
  }
}
