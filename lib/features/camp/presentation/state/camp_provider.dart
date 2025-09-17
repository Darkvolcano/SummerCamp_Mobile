import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:summercamp/features/camp/data/models/camp_model.dart';
import 'package:summercamp/features/camp/domain/entities/camp.dart';
import 'package:summercamp/features/camp/domain/use_cases/create_camp.dart';
import 'package:summercamp/features/camp/domain/use_cases/get_camps.dart';

class CampProvider with ChangeNotifier {
  final GetCamps getCampsUseCase;
  final CreateCamp createCampUseCase;

  CampProvider(this.getCampsUseCase, this.createCampUseCase);

  List<Camp> _camps = [];
  List<Camp> get camps => _camps;

  bool _loading = false;
  bool get loading => _loading;

  Future<void> loadCamps() async {
    _loading = true;
    notifyListeners();

    try {
      final jsonString = await rootBundle.loadString("assets/mock/camps.json");
      final List<dynamic> jsonList = json.decode(jsonString);

      _camps = jsonList.map((e) => CampModel.fromJson(e)).toList();

      // Uncomment if use this line to call API
      // _camps = await getCampsUseCase();
    } catch (e) {
      print("Lỗi load camps: $e");
      _camps = [];
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> addCamp(Camp camp) async {
    // await createCampUseCase(camp);

    _camps.add(camp);
    notifyListeners();
  }
}
