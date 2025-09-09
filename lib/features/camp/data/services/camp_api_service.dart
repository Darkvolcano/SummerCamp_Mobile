import '../../../../core/network/api_client.dart';

class CampApiService {
  final ApiClient client;
  CampApiService(this.client);

  Future<List<dynamic>> fetchCamps() async {
    final res = await client.get('camps');
    return res.data as List;
  }

  Future<Map<String, dynamic>> createCamp(Map<String, dynamic> data) async {
    final res = await client.post('camps', data: data);
    return res.data;
  }
}
