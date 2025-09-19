import 'package:summercamp/core/network/api_client.dart';

class CamperApiService {
  final ApiClient client;
  CamperApiService(this.client);

  Future<List<dynamic>> fetchCampers() async {
    final res = await client.get('campers');
    return res.data as List;
  }

  Future<Map<String, dynamic>> createCamper(Map<String, dynamic> data) async {
    final res = await client.post('campers', data: data);
    return res.data;
  }

  Future<Map<String, dynamic>> updateCamper(
    int id,
    Map<String, dynamic> data,
  ) async {
    final res = await client.put('campers/$id', data: data);
    return res.data;
  }
}
