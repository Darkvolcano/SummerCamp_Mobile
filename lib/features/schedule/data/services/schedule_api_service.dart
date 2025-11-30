import 'package:dio/dio.dart';
import 'package:summercamp/core/network/api_client.dart';
import 'package:summercamp/core/network/dio_error_mapper.dart';
import 'package:summercamp/features/schedule/domain/entities/update_camper_transport.dart';

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

  Future<List<dynamic>> fetchCampersTransportByTransportScheduleId(
    int transportScheduleId,
  ) async {
    final res = await client.get(
      'campertransport/schedule/$transportScheduleId',
    );
    return res.data as List;
  }

  Future<void> updateCampertransportAttendanceCheckIn(
    List<UpdateCamperTransport> requests,
  ) async {
    try {
      final data = requests.map((e) => e.toJson()).toList();

      await client.put('campertransport/check-in', data: data);
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  Future<void> updateCampertransportAttendanceCheckOut(
    List<UpdateCamperTransport> requests,
  ) async {
    try {
      final data = requests.map((e) => e.toJson()).toList();

      await client.put('campertransport/check-out', data: data);
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }
}
