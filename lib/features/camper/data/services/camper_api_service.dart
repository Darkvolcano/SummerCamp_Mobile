import 'package:dio/dio.dart';
import 'package:summercamp/core/network/api_client.dart';
import 'package:summercamp/core/network/dio_error_mapper.dart';

class CamperApiService {
  final ApiClient client;
  CamperApiService(this.client);

  Future<List<dynamic>> fetchCampers() async {
    final res = await client.get('Camper/my-campers');
    return res.data as List;
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
