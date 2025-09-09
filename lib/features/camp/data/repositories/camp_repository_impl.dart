import '../../domain/entities/camp.dart';
import '../../domain/repositories/camp_repository.dart';
import '../models/camp_model.dart';
import '../services/camp_api_service.dart';

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
}
