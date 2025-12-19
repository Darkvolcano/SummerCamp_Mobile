import 'dart:io';
import 'package:summercamp/features/album/domain/repositories/album_repository.dart';

class UploadImage {
  final AlbumRepository repository;
  UploadImage(this.repository);

  Future<void> call(File imageFile) {
    return repository.uploadImage(imageFile);
  }
}
