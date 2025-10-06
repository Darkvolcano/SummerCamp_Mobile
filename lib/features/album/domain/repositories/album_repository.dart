import 'package:summercamp/features/album/domain/entities/album.dart';
import 'package:summercamp/features/album/domain/entities/album_photo.dart';

abstract class AlbumRepository {
  Future<List<Album>> getAlbums();
  Future<void> uploadAlbumPhoto(AlbumPhoto albumPhoto);
}
