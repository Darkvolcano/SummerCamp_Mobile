import 'package:flutter/material.dart';
import 'package:summercamp/features/camper/domain/entities/camper.dart';
import 'package:summercamp/features/registration/domain/entities/registration.dart';
import 'package:summercamp/features/registration/domain/use_cases/cancel_registration.dart';
import 'package:summercamp/features/registration/domain/use_cases/get_registraion_by_id.dart';
import 'package:summercamp/features/registration/domain/use_cases/get_registration.dart';
import 'package:summercamp/features/registration/domain/use_cases/create_register.dart';

class RegistrationProvider with ChangeNotifier {
  final CreateRegister createRegisterUseCase;
  final CancelRegistration cancelUseCase;
  final GetRegistrations getRegistrationsUseCase;
  final GetRegistrationById getRegistrationByIdUseCase;

  RegistrationProvider(
    this.getRegistrationsUseCase,
    this.createRegisterUseCase,
    this.cancelUseCase,
    this.getRegistrationByIdUseCase,
  );

  List<Registration> _registrations = [];
  List<Registration> get registrations => _registrations;

  Registration? _selectedRegistration;
  Registration? get selectedRegistration => _selectedRegistration;

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
}
