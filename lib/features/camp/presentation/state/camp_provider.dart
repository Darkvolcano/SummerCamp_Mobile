import 'package:flutter/material.dart';
import 'package:summercamp/core/enum/camp_status.enum.dart';
import 'package:summercamp/features/camp/domain/entities/camp.dart';
import 'package:summercamp/features/camp/domain/entities/camp_type.dart';
import 'package:summercamp/features/camp/domain/use_cases/get_camp_types.dart';
import 'package:summercamp/features/camp/domain/use_cases/get_camps.dart';

class CampProvider with ChangeNotifier {
  final GetCamps getCampsUseCase;
  final GetCampTypes getCampTypesUseCase;

  CampProvider(this.getCampsUseCase, this.getCampTypesUseCase);

  List<Camp> _camps = [];
  List<Camp> get camps => _camps;

  List<Camp> _filteredCamps = [];
  List<Camp> get filteredCamps => _filteredCamps;

  List<CampType> _campTypes = [];
  List<CampType> get campTypes => _campTypes;

  bool _loading = false;
  bool get loading => _loading;

  int? _selectedCampTypeId;
  bool _isUpcomingSelected = false;

  int? get selectedCampTypeId => _selectedCampTypeId;
  bool get isUpcomingSelected => _isUpcomingSelected;

  Future<void> loadCamps() async {
    _loading = true;
    notifyListeners();

    try {
      _camps = await getCampsUseCase();
      _applyFilters();
    } catch (e) {
      print("Lỗi load camps: $e");
      _camps = [];
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> loadCampTypes() async {
    // _loading = true;
    // notifyListeners();

    try {
      _campTypes = await getCampTypesUseCase();
    } catch (e) {
      print("Lỗi load camp type: $e");
      _campTypes = [];
    }

    _loading = false;
    notifyListeners();
  }

  void selectCampType(int? typeId) {
    _selectedCampTypeId = typeId;
    _isUpcomingSelected = false;
    _applyFilters();
    notifyListeners();
  }

  void toggleUpcoming() {
    _isUpcomingSelected = !_isUpcomingSelected;
    if (_isUpcomingSelected) {
      _selectedCampTypeId = null;
    }
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    var temp = _camps;

    if (_isUpcomingSelected) {
      temp = temp.where((camp) => camp.status == CampStatus.Published).toList();
    } else {
      const allowedStatuses = {
        CampStatus.Published,
        CampStatus.OpenForRegistration,
        CampStatus.RegistrationClosed,
      };
      temp = temp
          .where((camp) => allowedStatuses.contains(camp.status))
          .toList();
    }

    if (_selectedCampTypeId != null) {
      temp = temp
          .where((camp) => camp.campType?.id == _selectedCampTypeId)
          .toList();
    }

    _filteredCamps = temp.toList();

    if (_isUpcomingSelected) {
      _filteredCamps.sort((a, b) => a.startDate.compareTo(b.startDate));
    }
  }

  void searchLocalCamps(String query) {
    if (query.isEmpty) {
      _filteredCamps = [];
    } else {
      _filteredCamps = _camps
          .where(
            (camp) => camp.name.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }
    notifyListeners();
  }

  void clearSearch() {
    _filteredCamps = [];
    notifyListeners();
  }
}
