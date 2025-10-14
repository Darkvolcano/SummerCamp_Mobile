import 'package:flutter/material.dart';
import 'package:summercamp/features/activity/domain/entities/activity.dart';
import 'package:summercamp/features/activity/domain/use_cases/get_activities_by_camp.dart';

class ActivityProvider with ChangeNotifier {
  final GetActivitiesByCampId getActivitiesByCampIdUseCase;

  ActivityProvider(this.getActivitiesByCampIdUseCase);

  List<Activity> _activities = [];
  List<Activity> get activities => _activities;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  void setError(String message) {
    _error = message;
    _loading = false;
    _activities = [];
    notifyListeners();
  }

  void setLoading() {
    _loading = true;
    _activities = [];
    _error = null;
    notifyListeners();
  }

  Future<void> loadActivities(int campId) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _activities = await getActivitiesByCampIdUseCase(campId);
    } catch (e) {
      _error = e.toString();
      _activities = [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
