import 'package:flutter/material.dart';
import '../../domain/entities/camp.dart';
import '../../domain/use_cases/get_camps.dart';
import '../../domain/use_cases/create_camp.dart';

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

    _camps = await getCampsUseCase();
    _loading = false;
    notifyListeners();
  }

  Future<void> addCamp(Camp camp) async {
    await createCampUseCase(camp);
    _camps.add(camp);
    notifyListeners();
  }
}
