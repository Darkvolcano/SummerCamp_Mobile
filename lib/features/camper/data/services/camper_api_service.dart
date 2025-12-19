import 'dart:io';

import 'package:dio/dio.dart';
import 'package:summercamp/core/network/api_client.dart';
import 'package:summercamp/core/network/dio_error_mapper.dart';

class CamperApiService {
  final ApiClient client;
  CamperApiService(this.client);

  Future<List<dynamic>> fetchCampers() async {
    final res = await client.get('Camper/my-campers');
    return res.data as List;
  }

  Future<List<dynamic>> fetchCampersByCoreActivity(int coreActivityId) async {
    final res = await client.get(
      'Camper/coreActivities/$coreActivityId/campers',
    );
    return res.data as List<dynamic>;
  }

  Future<List<dynamic>> fetchCampersByOptionalActivity(
    int optionalActivityId,
  ) async {
    final res = await client.get(
      'Camper/optionalActivities/$optionalActivityId/campers',
    );
    return res.data as List<dynamic>;
  }

  Future<List<dynamic>> fetchCamperByActivitySchedule(
    int activityScheduleId,
  ) async {
    final res = await client.get(
      'Camper/activitiySchedules/$activityScheduleId/campers',
    );
    return res.data as List<dynamic>;
  }

  Future<Map<String, dynamic>> createCamper({
    required Map<String, dynamic> data,
  }) async {
    try {
      final res = await client.post('Camper', data: data);
      return res.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  Future<void> updateCamper(int camperId, Map<String, dynamic> data) async {
    final res = await client.put('Camper/$camperId', data: data);
    return res.data;
  }

  Future<Map<String, dynamic>> fetchCamperById(int camperId) async {
    try {
      final res = await client.get('Camper/$camperId');
      return res.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  Future<List<dynamic>> getCamperGroupsByCampId(int campId) async {
    try {
      final response = await client.get(
        'campergroup',
        queryParameters: {'campId': campId},
      );
      return response.data as List;
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  Future<List<dynamic>> getCamperGroupsByGroupId(int groupId) async {
    try {
      final response = await client.get(
        'campergroup',
        queryParameters: {'groupId': groupId},
      );
      return response.data as List;
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  Future<Map<String, dynamic>> getCampGroup(int campId) async {
    try {
      final response = await client.get('Staff/camps/$campId/group');
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  Future<void> updateUploadAvatarCamper(int camperId, File imageFile) async {
    try {
      String fileName = imageFile.path.split('/').last;

      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      await client.put(
        'Camper/$camperId/avatar',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }
}
