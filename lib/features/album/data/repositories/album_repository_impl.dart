import 'package:summercamp/features/album/data/models/album_model.dart';
import 'package:summercamp/features/album/data/models/album_photo_model.dart';
import 'package:summercamp/features/album/data/services/album_api_service.dart';
import 'package:summercamp/features/album/domain/entities/album.dart';
import 'package:summercamp/features/album/domain/entities/album_photo.dart';
import 'package:summercamp/features/album/domain/repositories/album_repository.dart';

class AlbumRepositoryImpl implements AlbumRepository {
  final AlbumApiService service;
  AlbumRepositoryImpl(this.service);

  @override
  Future<List<Album>> getAlbums() async {
    final list = await service.fetchAlbums();
    return list.map((e) => AlbumModel.fromJson(e)).toList();
  }

  @override
  Future<void> uploadAlbumPhoto(AlbumPhoto albumPhoto) async {
    await service.uploadPhotoAlbum((albumPhoto as AlbumPhotoModel).toJson());
  }
}
