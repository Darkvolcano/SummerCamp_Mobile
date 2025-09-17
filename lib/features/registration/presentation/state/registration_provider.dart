import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:summercamp/features/registration/domain/entities/registration.dart';
import 'package:summercamp/features/registration/domain/use_cases/cancel_registration.dart';
import 'package:summercamp/features/registration/domain/use_cases/get_registration.dart';
import 'package:summercamp/features/registration/domain/use_cases/register_camper.dart';
import 'package:summercamp/features/registration/data/models/registration_model.dart';

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

    final jsonString = await rootBundle.loadString(
      'assets/mock/registrations.json',
    );

    final List<dynamic> jsonList = json.decode(jsonString);

    _registrations = jsonList
        .map((e) => RegistrationModel.fromJson(e))
        .toList();

    // _registrations = await getRegistrationsUseCase();

    _loading = false;
    notifyListeners();
  }

  Future<void> addRegistration(Registration r) async {
    await registerUseCase(r);
    _registrations.add(r);
    notifyListeners();
  }

  Future<void> removeRegistration(int id) async {
    await cancelUseCase(id);
    _registrations.removeWhere((r) => r.id == id);
    notifyListeners();
  }
}
