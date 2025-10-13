import 'package:flutter/material.dart';
import 'package:summercamp/features/camp/domain/entities/camp.dart';
import 'package:summercamp/features/camp/domain/entities/camp_type.dart';
import 'package:summercamp/features/camp/domain/use_cases/create_camp.dart';
import 'package:summercamp/features/camp/domain/use_cases/get_camp_types.dart';
import 'package:summercamp/features/camp/domain/use_cases/get_camps.dart';

class CampProvider with ChangeNotifier {
  final GetCamps getCampsUseCase;
  final CreateCamp createCampUseCase;
  final GetCampTypes getCampTypesUseCase;

  CampProvider(
    this.getCampsUseCase,
    this.createCampUseCase,
    this.getCampTypesUseCase,
  );

  List<Camp> _camps = [];
  List<Camp> get camps => _camps;

  List<CampType> _campTypes = [];
  List<CampType> get campTypes => _campTypes;

  bool _loading = false;
  bool get loading => _loading;

  Future<void> loadCamps() async {
    _loading = true;
    notifyListeners();

    try {
      _camps = await getCampsUseCase();
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

  Future<void> loadCampTypes() async {
    _loading = true;
    notifyListeners();

    try {
      _campTypes = await getCampTypesUseCase();
    } catch (e) {
      print("Lỗi load camp type: $e");
      _campTypes = [];
    }

    _loading = false;
    notifyListeners();
  }
}
