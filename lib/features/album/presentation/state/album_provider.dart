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

  String? _error;
  String? get error => _error;

  Future<void> loadAlbums(int campId) async {
    _loading = true;
    _error = null;
    try {
      _albums = await getAlbumsUseCase(campId);
    } catch (e) {
      print("Lỗi load albums: $e");
      _error = e.toString();
      _albums = [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> uploadPhotoToAlbum(
    int albumId, {
    required List<File> images,
  }) async {
    try {
      await uploadPhotoAlbumUseCase(albumId, images: images);
    } catch (e) {
      rethrow;
    }
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
