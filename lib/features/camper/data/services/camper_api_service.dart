import 'package:dio/dio.dart';
import 'package:summercamp/core/network/api_client.dart';
import 'package:summercamp/core/network/dio_error_mapper.dart';

class CamperApiService {
  final ApiClient client;
  CamperApiService(this.client);

  Future<List<dynamic>> fetchCampers() async {
    final res = await client.get('Camper');
    return res.data as List;
  }

  Future<List<dynamic>> fetchCampersByCoreActivity(int coreActivityId) async {
    final res = await client.get(
      'Camper/coreActivities/$coreActivityId/campers',
    );
    return res.data as List<dynamic>;
  }

  Future<List<dynamic>> fetchCampersByOptionalActivity(
    int optionalActivityId,
  ) async {
    final res = await client.get(
      'Camper/optionalActivities/$optionalActivityId/campers',
    );
    return res.data as List<dynamic>;
  }

  Future<Map<String, dynamic>> createCamper({
    required Map<String, dynamic> data,
  }) async {
    try {
      final res = await client.post('Camper', data: data);
      return res.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  Future<void> updateCamper(int camperId, Map<String, dynamic> data) async {
    final res = await client.put('Camper/$camperId', data: data);
    return res.data;
  }

  Future<Map<String, dynamic>> fetchCamperById(int camperId) async {
    try {
      final res = await client.get('Camper/$camperId');
      return res.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  Future<List<dynamic>> fetchCamperGroups() async {
    final res = await client.get('campergroup');
    return res.data as List;
  }
}
