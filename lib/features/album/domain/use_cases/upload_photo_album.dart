import 'package:summercamp/features/album/domain/repositories/album_repository.dart';

class UploadPhotoAlbum {
  final AlbumRepository repository;

  UploadPhotoAlbum(this.repository);

  Future<void> call(int campId, {required List<String> images}) async {
    await repository.uploadAlbumPhoto(campId, images: images);
  }
}
