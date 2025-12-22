import 'dart:io';

import 'package:summercamp/features/album/domain/entities/album.dart';

abstract class AlbumRepository {
  Future<List<Album>> getAlbumsByCampId(int campId);
  Future<void> uploadAlbumPhoto(int albumId, {required List<File> images});
  Future<String> uploadImage(File imageFile);
}
