import 'package:summercamp/features/album/domain/entities/album.dart';

abstract class AlbumRepository {
  Future<List<Album>> getAlbums();
  Future<void> uploadAlbumPhoto(int campId, {required List<String> images});
}
