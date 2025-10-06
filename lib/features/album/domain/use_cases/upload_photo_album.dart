import 'package:summercamp/features/album/domain/entities/album_photo.dart';
import 'package:summercamp/features/album/domain/repositories/album_repository.dart';

class UploadPhotoAlbum {
  final AlbumRepository repository;

  UploadPhotoAlbum(this.repository);

  Future<void> call(AlbumPhoto album) async {
    return await repository.uploadAlbumPhoto(album);
  }
}
