import 'package:summercamp/core/network/api_client.dart';

class ActivityApiService {
  final ApiClient client;
  ActivityApiService(this.client);

  Future<List<dynamic>> fetchActivitySchedulesByCampId(int campId) async {
    final res = await client.get('ActivitySchedule/camp/$campId');
    return res.data as List;
  }

  Future<List<dynamic>> fetchActivitySchedulesOptionalByCampId(
    int campId,
  ) async {
    final res = await client.get('ActivitySchedule/optional/camp/$campId');
    return res.data as List;
  }

  Future<List<dynamic>> fetchActivitySchedulesCoreByCampId(int campId) async {
    final res = await client.get('ActivitySchedule/core/camp/$campId');
    return res.data as List;
  }
}
