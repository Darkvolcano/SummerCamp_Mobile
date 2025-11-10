import 'package:flutter/material.dart';
import 'package:summercamp/features/activity/domain/entities/activity_schedule.dart';
import 'package:summercamp/features/activity/domain/use_cases/get_activity_schedule_by_camp_id.dart';
import 'package:summercamp/features/activity/domain/use_cases/get_activity_schedule_core_by_camp_id.dart';
import 'package:summercamp/features/activity/domain/use_cases/get_activity_schedule_optional_by_camp_id.dart';

class ActivityProvider with ChangeNotifier {
  final GetActivitySchedulesByCampId getActivitySchedulesByCampIdUseCase;
  final GetActivitySchedulesOptionalByCampId
  getActivitySchedulesOptionalByCampIdUseCase;
  final GetActivitySchedulesCoreByCampId
  getActivitySchedulesCoreByCampIdUseCase;

  ActivityProvider(
    this.getActivitySchedulesOptionalByCampIdUseCase,
    this.getActivitySchedulesCoreByCampIdUseCase,
    this.getActivitySchedulesByCampIdUseCase,
  );

  List<ActivitySchedule> _activitySchedules = [];
  List<ActivitySchedule> get activitySchedules => _activitySchedules;

  List<ActivitySchedule> _coreActivitySchedules = [];
  List<ActivitySchedule> get coreActivitySchedules => _coreActivitySchedules;

  List<ActivitySchedule> _optionalActivitySchedules = [];
  List<ActivitySchedule> get optionalActivitySchedules =>
      _optionalActivitySchedules;

  bool _loading = false;
  String? _error;

  bool get loading => _loading;
  String? get error => _error;

  Future<void> loadActivitySchedulesByCampId(int campId) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _activitySchedules = await getActivitySchedulesByCampIdUseCase(campId);
    } catch (e) {
      _error = e.toString();
      _activitySchedules = [];
      print('Lỗi khi tải danh sách hoạt động: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> loadActivitySchedulesOptionalByCampId(int campId) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _optionalActivitySchedules =
          await getActivitySchedulesOptionalByCampIdUseCase(campId);
    } catch (e) {
      _error = e.toString();
      _optionalActivitySchedules = [];
      print('Lỗi khi tải danh sách hoạt động tự chọn: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> loadActivitySchedulesCoreByCampId(int campId) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _coreActivitySchedules = await getActivitySchedulesCoreByCampIdUseCase(
        campId,
      );
    } catch (e) {
      _error = e.toString();
      _coreActivitySchedules = [];
      print('Lỗi khi tải danh sách hoạt động bắt buộc: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
