import 'package:summercamp/features/camp/data/models/camp_model.dart';
import 'package:summercamp/features/camp/data/models/camp_type_model.dart';
import 'package:summercamp/features/camp/data/services/camp_api_service.dart';
import 'package:summercamp/features/camp/domain/entities/camp.dart';
import 'package:summercamp/features/camp/domain/entities/camp_type.dart';
import 'package:summercamp/features/camp/domain/repositories/camp_repository.dart';

class CampRepositoryImpl implements CampRepository {
  final CampApiService service;
  CampRepositoryImpl(this.service);

  @override
  Future<List<Camp>> getCamps() async {
    final list = await service.fetchCamps();
    return list.map((e) => CampModel.fromJson(e)).toList();
  }

  @override
  Future<void> createCamp(Camp camp) async {
    await service.createCamp((camp as CampModel).toJson());
  }

  @override
  Future<List<CampType>> getCampTypes() async {
    final list = await service.fetchCampTypes();
    return list.map((e) => CampTypeModel.fromJson(e)).toList();
  }
}
