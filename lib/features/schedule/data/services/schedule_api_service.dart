import 'package:summercamp/core/network/api_client.dart';

class ScheduleApiService {
  final ApiClient client;
  ScheduleApiService(this.client);

  Future<List<dynamic>> fetchSchedules() async {
    final res = await client.get('Staff/my-camps');
    return res.data as List;
  }
}
