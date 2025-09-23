import 'package:summercamp/core/network/api_client.dart';

class ReportApiService {
  final ApiClient client;
  ReportApiService(this.client);

  Future<List<dynamic>> fetchReports() async {
    final res = await client.get('reports');
    return res.data as List;
  }

  Future<Map<String, dynamic>> createReport(Map<String, dynamic> data) async {
    final res = await client.post('reports', data: data);
    return res.data;
  }
}
