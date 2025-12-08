import 'package:dio/dio.dart';
import 'package:summercamp/core/network/api_client.dart';
import 'package:summercamp/core/network/dio_error_mapper.dart';

class ScheduleApiService {
  final ApiClient client;
  ScheduleApiService(this.client);

  Future<List<dynamic>> fetchStaffSchedules() async {
    final res = await client.get('Staff/my-camps');
    return res.data as List;
  }

  Future<void> updateTransportScheduleStartTrip(int transportScheduleId) async {
    await client.patch('transport-schedules/$transportScheduleId/start-trip');
  }

  Future<void> updateTransportScheduleEndTrip(int transportScheduleId) async {
    await client.patch('transport-schedules/$transportScheduleId/end-trip');
  }

  Future<List<dynamic>> fetchDriverSchedules() async {
    final res = await client.get('transport-schedules/driver-schedule');
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

  Future<void> updateCampertransportAttendanceCheckIn({
    required List<int> camperTransportIds,
    String? note,
  }) async {
    try {
      await client.patch(
        'campertransport/check-in',
        data: {'camperTransportIds': camperTransportIds, 'note': note},
      );
    } on DioException catch (e) {
      if (e.response != null && e.response!.data is Map) {
        final data = e.response!.data as Map;
        if (data['message'] != null) {
          throw Exception(data['message']);
        }
      }
      throw mapDioError(e);
    }
  }

  Future<void> updateCampertransportAttendanceCheckOut({
    required List<int> camperTransportIds,
    String? note,
  }) async {
    try {
      await client.patch(
        'campertransport/check-out',
        data: {'camperTransportIds': camperTransportIds, 'note': note},
      );
    } on DioException catch (e) {
      if (e.response != null && e.response!.data is Map) {
        final data = e.response!.data as Map;
        if (data['message'] != null) {
          throw Exception(data['message']);
        }
      }
      throw mapDioError(e);
    }
  }
}
