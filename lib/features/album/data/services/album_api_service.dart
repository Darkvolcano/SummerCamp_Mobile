import 'dart:io';

import 'package:dio/dio.dart';
import 'package:summercamp/core/network/api_client.dart';
import 'package:summercamp/core/network/dio_error_mapper.dart';

class AlbumApiService {
  final ApiClient client;
  AlbumApiService(this.client);

  Future<List<dynamic>> fetchAlbumsByCampId(int campId) async {
    try {
      final res = await client.get('album/camp/$campId');
      return res.data as List;
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  Future<void> uploadPhotoToAlbum(
    int albumId, {
    required List<File> images,
  }) async {
    try {
      FormData formData = FormData.fromMap({'albumId': albumId});

      for (var file in images) {
        String fileName = file.path.split('/').last;
        formData.files.add(
          MapEntry(
            'photos',
            await MultipartFile.fromFile(file.path, filename: fileName),
          ),
        );
      }

      await client.post(
        'album-photo/bulk',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          sendTimeout: const Duration(minutes: 5),
        ),
      );
    } on DioException catch (e) {
      throw mapDioError(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> fetchPhotoByAlbumId(int albumId) async {
    try {
      final res = await client.get('album-photo/album/$albumId');
      return res.data as List;
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  Future<String> uploadImage(File imageFile) async {
    try {
      String fileName = imageFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      final response = await client.post(
        'upload/image',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      return response.data['url'] as String;
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }
}
