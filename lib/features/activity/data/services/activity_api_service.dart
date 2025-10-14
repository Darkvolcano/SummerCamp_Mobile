import 'package:summercamp/core/network/api_client.dart';

class ActivityApiService {
  final ApiClient client;
  ActivityApiService(this.client);

  Future<List<dynamic>> fetchActivities() async {
    final res = await client.get('Activity');
    return res.data as List;
  }

  Future<List<dynamic>> fetchActivitiesByCampId(int campId) async {
    final res = await client.get('Activity/camp/$campId');
    return res.data as List;
  }
}
