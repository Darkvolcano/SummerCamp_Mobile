import 'dart:io';

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
  Future<List<Album>> getAlbumsByCampId(int campId) async {
    final list = await service.fetchAlbumsByCampId(campId);
    return list.map((e) => AlbumModel.fromJson(e)).toList();
  }

  @override
  Future<void> uploadAlbumPhoto(
    int albumId, {
    required List<File> images,
  }) async {
    return await service.uploadPhotoToAlbum(albumId, images: images);
  }

  @override
  Future<List<AlbumPhoto>> getPhotoByAlbumId(int albumId) async {
    final list = await service.fetchPhotoByAlbumId(albumId);
    return list.map((e) => AlbumPhotoModel.fromJson(e)).toList();
  }

  @override
  Future<String> uploadImage(File imageFile) async {
    return await service.uploadImage(imageFile);
  }
}
