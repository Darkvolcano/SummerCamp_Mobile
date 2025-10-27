import 'package:flutter/material.dart';
import 'package:summercamp/features/camper/domain/entities/camper.dart';
import 'package:summercamp/features/registration/domain/entities/activity_schedule.dart';
import 'package:summercamp/features/registration/domain/entities/optional_choice.dart';
import 'package:summercamp/features/registration/domain/entities/registration.dart';
import 'package:summercamp/features/registration/domain/use_cases/cancel_registration.dart';
import 'package:summercamp/features/registration/domain/use_cases/create_register_camper_activity.dart';
import 'package:summercamp/features/registration/domain/use_cases/create_register_payment_link.dart';
import 'package:summercamp/features/registration/domain/use_cases/get_activity_schedule_core_by_camp_id.dart';
import 'package:summercamp/features/registration/domain/use_cases/get_activity_schedule_optional_by_camp_id.dart';
import 'package:summercamp/features/registration/domain/use_cases/get_registraion_by_id.dart';
import 'package:summercamp/features/registration/domain/use_cases/get_registration.dart';
import 'package:summercamp/features/registration/domain/use_cases/create_register.dart';

class RegistrationProvider with ChangeNotifier {
  final CreateRegister createRegisterUseCase;
  final CancelRegistration cancelUseCase;
  final GetRegistrations getRegistrationsUseCase;
  final GetRegistrationById getRegistrationByIdUseCase;
  final CreateRegisterPaymentLink createRegisterPaymentLinkUseCase;
  final CreateRegisterOptionalCamperActivity
  createRegisterOptionalCamperActivityUseCase;
  final GetActivitySchedulesOptionalByCampId
  getActivitySchedulesOptionalByCampIdUseCase;
  final GetActivitySchedulesCoreByCampId
  getActivitySchedulesCoreByCampIdUseCase;

  RegistrationProvider(
    this.getRegistrationsUseCase,
    this.createRegisterUseCase,
    this.cancelUseCase,
    this.getRegistrationByIdUseCase,
    this.createRegisterPaymentLinkUseCase,
    this.createRegisterOptionalCamperActivityUseCase,
    this.getActivitySchedulesOptionalByCampIdUseCase,
    this.getActivitySchedulesCoreByCampIdUseCase,
  );

  List<Registration> _registrations = [];
  List<Registration> get registrations => _registrations;

  Registration? _selectedRegistration;
  Registration? get selectedRegistration => _selectedRegistration;

  List<ActivitySchedule> _activitySchedules = [];
  List<ActivitySchedule> get activitySchedules => _activitySchedules;

  ActivitySchedule? _selectedActivitySchedule;
  ActivitySchedule? get selectedActivitySchedule => _selectedActivitySchedule;

  bool _loading = false;
  String? _error;

  bool get loading => _loading;
  String? get error => _error;

  Future<void> loadRegistrations() async {
    _loading = true;
    notifyListeners();

    try {
      _registrations = await getRegistrationsUseCase();
    } catch (e) {
      _error = e.toString();
      _registrations = [];
      print('Lỗi khi tải danh sách đăng ký: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> createRegistration({
    required int campId,
    required List<Camper> campers,
    String? appliedPromotionId,
    String? note,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final camperIds = campers.map((c) => c.camperId).toList();

      await createRegisterUseCase(
        campId: campId,
        camperIds: camperIds,
        appliedPromotionId: appliedPromotionId,
        note: note,
      );
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<String> createRegistrationPaymentLink({
    required int registrationId,
    List<OptionalChoice>? optionalChoices,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final paymentUrl = await createRegisterPaymentLinkUseCase(
        registrationId: registrationId,
        optionalChoices: optionalChoices,
      );
      return paymentUrl;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> removeRegistration(int registrationId) async {
    await cancelUseCase(registrationId);
    _registrations.removeWhere((r) => r.registrationId == registrationId);
    notifyListeners();
  }

  Future<void> loadRegistrationDetails(int registrationId) async {
    _loading = true;
    _error = null;
    _selectedRegistration = null;
    notifyListeners();

    try {
      _selectedRegistration = await getRegistrationByIdUseCase(registrationId);
    } catch (e) {
      _error = e.toString();
      print('Lỗi khi tải chi tiết đăng ký: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> createRegisterOptionalCamperActivity({
    required int camperId,
    required int activityId,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      await createRegisterOptionalCamperActivityUseCase(
        camperId: camperId,
        activityId: activityId,
      );
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> loadActivitySchedulesOptionalByCampId(int campId) async {
    _loading = true;
    _error = null;
    _selectedActivitySchedule = null;
    notifyListeners();

    try {
      _activitySchedules = await getActivitySchedulesOptionalByCampIdUseCase(
        campId,
      );
    } catch (e) {
      _error = e.toString();
      _activitySchedules = [];
      print('Lỗi khi tải danh sách hoạt động tự chọn: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> loadActivitySchedulesCoreByCampId(int campId) async {
    _loading = true;
    _error = null;
    _selectedActivitySchedule = null;
    notifyListeners();

    try {
      _activitySchedules = await getActivitySchedulesCoreByCampIdUseCase(
        campId,
      );
    } catch (e) {
      _error = e.toString();
      _activitySchedules = [];
      print('Lỗi khi tải danh sách hoạt động bắt buộc: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
