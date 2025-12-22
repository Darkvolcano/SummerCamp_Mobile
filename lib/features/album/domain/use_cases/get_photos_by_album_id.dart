import 'package:summercamp/features/album/domain/entities/album_photo.dart';
import 'package:summercamp/features/album/domain/repositories/album_repository.dart';

class GetPhotosByAlbumId {
  final AlbumRepository repository;
  GetPhotosByAlbumId(this.repository);

  Future<List<AlbumPhoto>> call(int albumId) async {
    return await repository.getPhotoByAlbumId(albumId);
  }
}
