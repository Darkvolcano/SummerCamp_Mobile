import 'package:flutter/material.dart';
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
}
