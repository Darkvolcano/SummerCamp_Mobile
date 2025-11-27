import 'package:summercamp/core/network/api_client.dart';

class ScheduleApiService {
  final ApiClient client;
  ScheduleApiService(this.client);

  Future<List<dynamic>> fetchStaffSchedules() async {
    final res = await client.get('Staff/my-camps');
    return res.data as List;
  }

  Future<void> updateTransportScheduleStartTrip(int transportScheduleId) async {
    await client.patch('transportschedules/$transportScheduleId/start-trip');
  }

  Future<void> updateTransportScheduleEndTrip(int transportScheduleId) async {
    await client.patch('transportschedules/$transportScheduleId/end-trip');
  }

  Future<List<dynamic>> fetchDriverSchedules() async {
    final res = await client.get('transportschedules/driver-schedule');
    return res.data as List;
  }
}
