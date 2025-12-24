import 'dart:io';
import 'package:flutter/material.dart';
import 'package:summercamp/features/album/domain/entities/album.dart';
import 'package:summercamp/features/album/domain/entities/album_photo.dart';
import 'package:summercamp/features/album/domain/use_cases/get_albums_by_camp_id.dart';
import 'package:summercamp/features/album/domain/use_cases/get_photos_by_album_id.dart';
import 'package:summercamp/features/album/domain/use_cases/upload_image.dart';
import 'package:summercamp/features/album/domain/use_cases/upload_photo_album.dart';

class AlbumProvider with ChangeNotifier {
  final GetAlbumsByCampId getAlbumsByCampIdUseCase;
  final UploadPhotoAlbum uploadPhotoAlbumUseCase;
  final GetPhotosByAlbumId getPhotosByAlbumIdUseCase;
  final UploadImage uploadImageUseCase;

  AlbumProvider(
    this.getAlbumsByCampIdUseCase,
    this.uploadPhotoAlbumUseCase,
    this.getPhotosByAlbumIdUseCase,
    this.uploadImageUseCase,
  );

  List<Album> _albums = [];
  List<Album> get albums => _albums;

  List<AlbumPhoto> _albumPhotos = [];
  List<AlbumPhoto> get albumPhotos => _albumPhotos;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  final List<Album> _album = [];
  List<Album> get album => _album;

  final Map<int, List<AlbumPhoto>> _albumPhoto = {};

  bool _loadingAlbum = false;
  bool get loadingAlbum => _loadingAlbum;

  final Set<int> _fetchingAlbums = {};

  List<AlbumPhoto>? getPhotosByAlbumId(int albumId) {
    return _albumPhoto[albumId];
  }

  Future<void> loadAlbum(int campId) async {
    _loadingAlbum = true;
    notifyListeners();

    try {
      final result = await getAlbumsByCampIdUseCase.call(campId);

      _albums = result;
    } catch (e) {
      debugPrint("AlbumProvider Error (loadAlbums): $e");
      _albums = [];
    } finally {
      _loadingAlbum = false;
      notifyListeners();
    }
  }

  Future<void> loadPhoto(int albumId) async {
    if (_albumPhoto.containsKey(albumId) && _albumPhoto[albumId]!.isNotEmpty) {
      return;
    }

    if (_fetchingAlbums.contains(albumId)) {
      return;
    }

    _fetchingAlbums.add(albumId);

    try {
      final result = await getPhotosByAlbumIdUseCase.call(albumId);

      _albumPhoto[albumId] = result;
    } catch (e) {
      debugPrint("AlbumProvider Error (loadPhotos - $albumId): $e");
      _albumPhoto[albumId] = [];
    } finally {
      _fetchingAlbums.remove(albumId);
      notifyListeners();
    }
  }

  Future<void> loadAlbums(int campId) async {
    _loading = true;
    _error = null;
    try {
      _albums = await getAlbumsByCampIdUseCase(campId);
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

  Future<void> loadPhotos(int albumId) async {
    _loading = true;
    _error = null;
    try {
      _albumPhotos = await getPhotosByAlbumIdUseCase(albumId);
    } catch (e) {
      print("Lỗi load photo: $e");
      _error = e.toString();
      _albumPhotos = [];
    } finally {
      _loading = false;
      notifyListeners();
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
