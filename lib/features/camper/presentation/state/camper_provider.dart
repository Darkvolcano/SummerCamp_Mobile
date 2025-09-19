import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:summercamp/features/camper/data/models/camper_model.dart';
import 'package:summercamp/features/camper/domain/entities/camper.dart';
import 'package:summercamp/features/camper/domain/use_cases/create_camper.dart';
import 'package:summercamp/features/camper/domain/use_cases/get_camper.dart';
import 'package:summercamp/features/camper/domain/use_cases/update_camper.dart';

class CamperProvider with ChangeNotifier {
  final CreateCamper createCamperUseCase;
  final GetCampers getCampersUseCase;
  final UpdateCamper updateCamperUseCase;

  CamperProvider(
    this.createCamperUseCase,
    this.getCampersUseCase,
    this.updateCamperUseCase,
  );

  List<Camper> _campers = [];
  List<Camper> get campers => _campers;

  bool _loading = false;
  bool get loading => _loading;

  Future<void> loadCampers() async {
    _loading = true;
    notifyListeners();

    final jsonString = await rootBundle.loadString('assets/mock/campers.json');

    final List<dynamic> jsonList = json.decode(jsonString);

    _campers = jsonList.map((e) => CamperModel.fromJson(e)).toList();

    // _campers = await getCampersUseCase();

    _loading = false;
    notifyListeners();
  }

  Future<void> createCamper(Camper camper) async {
    await createCamperUseCase(camper);
    _campers.add(camper);
    notifyListeners();
  }

  Future<void> updateCamper(int id, Camper camper) async {
    await updateCamperUseCase(id, camper);

    final index = _campers.indexWhere((c) => c.id == id);
    if (index != -1) {
      _campers[index] = camper;
      notifyListeners();
    }
  }
}
