import 'dart:io';

import 'package:flutter/material.dart';
import 'package:summercamp/features/album/domain/entities/album.dart';
import 'package:summercamp/features/album/domain/entities/album_photo.dart';
import 'package:summercamp/features/album/domain/use_cases/get_albums.dart';
import 'package:summercamp/features/album/domain/use_cases/upload_image.dart';
import 'package:summercamp/features/album/domain/use_cases/upload_photo_album.dart';

class AlbumProvider with ChangeNotifier {
  final GetAlbums getAlbumsUseCase;
  final UploadPhotoAlbum uploadPhotoAlbumUseCase;
  final UploadImage uploadImageUseCase;

  AlbumProvider(
    this.getAlbumsUseCase,
    this.uploadPhotoAlbumUseCase,
    this.uploadImageUseCase,
  );

  List<Album> _albums = [];
  List<Album> get albums => _albums;

  final List<AlbumPhoto> _albumPhotos = [];
  List<AlbumPhoto> get albumPhotos => _albumPhotos;

  bool _loading = false;
  bool get loading => _loading;

  Future<void> loadAlbums() async {
    _loading = true;
    notifyListeners();

    try {
      _albums = await getAlbumsUseCase();
    } catch (e) {
      print("Lỗi load albums: $e");
      _albums = [];
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> uploadPhotoAlbum(
    int campId, {
    required List<String> images,
  }) async {
    await uploadPhotoAlbumUseCase(campId, images: images);
    notifyListeners();
  }

  Future<String> uploadImage(File imageFile) async {
    try {
      return await uploadImageUseCase(imageFile);
    } catch (e) {
      print("Lỗi upload ảnh: $e");
      rethrow;
    }
  }
}
