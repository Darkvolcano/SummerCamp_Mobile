import 'package:summercamp/core/network/api_client.dart';

class RegistrationApiService {
  final ApiClient client;
  RegistrationApiService(this.client);

  Future<List<dynamic>> fetchRegistrations() async {
    final res = await client.get('registrations');
    return res.data as List;
  }

  Future<Map<String, dynamic>> registerCamper(Map<String, dynamic> data) async {
    final res = await client.post('registrations', data: data);
    return res.data;
  }

  Future<void> cancelRegistration(String id) async {
    await client.delete('registrations/$id');
  }
}
