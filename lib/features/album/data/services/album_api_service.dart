import 'package:dio/dio.dart';
import 'package:summercamp/core/network/api_client.dart';
import 'package:summercamp/core/network/dio_error_mapper.dart';

class AlbumApiService {
  final ApiClient client;
  AlbumApiService(this.client);

  Future<List<dynamic>> fetchAlbums() async {
    final res = await client.get('albums');
    return res.data as List;
  }

  Future<void> uploadPhotoAlbum(
    int campId, {
    required List<String> images,
  }) async {
    try {
      await client.post('album/$campId/upload', data: {'images': images});
    } on DioException catch (e) {
      throw mapDioError(e);
    } catch (e) {
      rethrow;
    }
  }
}
