import 'package:summercamp/core/network/api_client.dart';

class CampApiService {
  final ApiClient client;
  CampApiService(this.client);

  Future<List<dynamic>> fetchCamps() async {
    final res = await client.get('camp');
    return res.data as List;
  }

  Future<List<dynamic>> fetchCampTypes() async {
    final res = await client.get('camptype');
    return res.data as List;
  }
}
