import 'dart:io';

import 'package:summercamp/features/album/domain/entities/album.dart';
import 'package:summercamp/features/album/domain/entities/album_photo.dart';

abstract class AlbumRepository {
  Future<List<Album>> getAlbumsByCampId(int campId);
  Future<void> uploadAlbumPhoto(int albumId, {required List<File> images});
  Future<List<AlbumPhoto>> getPhotoByAlbumId(int albumId);
  Future<String> uploadImage(File imageFile);
}
