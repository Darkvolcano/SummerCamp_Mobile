import 'dart:io';

import 'package:summercamp/features/album/domain/repositories/album_repository.dart';

class UploadPhotoAlbum {
  final AlbumRepository repository;

  UploadPhotoAlbum(this.repository);

  Future<void> call(int albumId, {required List<File> images}) async {
    await repository.uploadAlbumPhoto(albumId, images: images);
  }
}
