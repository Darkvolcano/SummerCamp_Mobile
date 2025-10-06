import 'package:summercamp/core/network/api_client.dart';

class AlbumApiService {
  final ApiClient client;
  AlbumApiService(this.client);

  Future<List<dynamic>> fetchAlbums() async {
    final res = await client.get('albums');
    return res.data as List;
  }

  Future<Map<String, dynamic>> uploadPhotoAlbum(
    Map<String, dynamic> data,
  ) async {
    final res = await client.post('album', data: data);
    return res.data;
  }
}
