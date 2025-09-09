import 'package:flutter/material.dart';
import 'package:summercamp/features/registration/domain/entities/registration.dart';
import 'package:summercamp/features/registration/domain/use_cases/cancel_registration.dart';
import 'package:summercamp/features/registration/domain/use_cases/get_registration.dart';
import 'package:summercamp/features/registration/domain/use_cases/register_camper.dart';

class RegistrationProvider with ChangeNotifier {
  final RegisterCamper registerUseCase;
  final CancelRegistration cancelUseCase;
  final GetRegistrations getRegistrationsUseCase;

  RegistrationProvider(
    this.getRegistrationsUseCase,
    this.registerUseCase,
    this.cancelUseCase,
  );

  List<Registration> _registrations = [];
  List<Registration> get registrations => _registrations;

  bool _loading = false;
  bool get loading => _loading;

  Future<void> loadRegistrations() async {
    _loading = true;
    notifyListeners();

    _registrations = await getRegistrationsUseCase();
    _loading = false;
    notifyListeners();
  }

  Future<void> addRegistration(Registration r) async {
    await registerUseCase(r);
    _registrations.add(r);
    notifyListeners();
  }

  Future<void> removeRegistration(String id) async {
    await cancelUseCase(id);
    _registrations.removeWhere((r) => r.id == id);
    notifyListeners();
  }
}
