import 'package:summercamp/features/album/domain/entities/album.dart';
import 'package:summercamp/features/album/domain/repositories/album_repository.dart';

class GetAlbumsByCampId {
  final AlbumRepository repository;
  GetAlbumsByCampId(this.repository);

  Future<List<Album>> call(int campId) async {
    return await repository.getAlbumsByCampId(campId);
  }
}
