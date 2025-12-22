import 'package:flutter/material.dart';
import 'package:summercamp/features/camper/domain/entities/camper.dart';
import 'package:summercamp/features/registration/domain/entities/optional_choice.dart';
import 'package:summercamp/features/registration/domain/entities/registration.dart';
import 'package:summercamp/features/registration/domain/entities/registration_camper_response.dart';
import 'package:summercamp/features/registration/domain/use_cases/cancel_registration.dart';
import 'package:summercamp/features/registration/domain/use_cases/create_register_camper_activity.dart';
import 'package:summercamp/features/registration/domain/use_cases/create_register_payment_link.dart';
import 'package:summercamp/features/registration/domain/use_cases/get_registraion_by_id.dart';
import 'package:summercamp/features/registration/domain/use_cases/get_registration.dart';
import 'package:summercamp/features/registration/domain/use_cases/create_register.dart';
import 'package:summercamp/features/registration/domain/use_cases/get_registration_camper.dart';
import 'package:summercamp/features/registration/domain/use_cases/refund_registration.dart';

class RegistrationProvider with ChangeNotifier {
  final CreateRegister createRegisterUseCase;
  final CancelRegistration cancelUseCase;
  final GetRegistrations getRegistrationsUseCase;
  final GetRegistrationById getRegistrationByIdUseCase;
  final CreateRegisterPaymentLink createRegisterPaymentLinkUseCase;
  final CreateRegisterOptionalCamperActivity
  createRegisterOptionalCamperActivityUseCase;
  final GetRegistrationCamper getRegistrationCamperUseCase;
  final RefundRegistration refundRegistrationUseCase;

  RegistrationProvider(
    this.getRegistrationsUseCase,
    this.createRegisterUseCase,
    this.cancelUseCase,
    this.getRegistrationByIdUseCase,
    this.createRegisterPaymentLinkUseCase,
    this.createRegisterOptionalCamperActivityUseCase,
    this.getRegistrationCamperUseCase,
    this.refundRegistrationUseCase,
  );

  List<Registration> _registrations = [];
  List<Registration> get registrations => _registrations;

  Registration? _selectedRegistration;
  Registration? get selectedRegistration => _selectedRegistration;

  List<RegistrationCamperResponse> _registrationCampers = [];
  List<RegistrationCamperResponse> get registrationCampers =>
      _registrationCampers;

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
    int? appliedPromotionId,
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

  Future<void> loadRegistrationCampers() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _registrationCampers = await getRegistrationCamperUseCase();
    } catch (e) {
      _error = e.toString();
      _registrationCampers = [];
      print("Lỗi load registration campers: $e");
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> refundRegistration({
    required int registrationId,
    required int bankUserId,
    required String reason,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      await refundRegistrationUseCase(
        registrationId: registrationId,
        bankUserId: bankUserId,
        reason: reason,
      );
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
