import 'package:summercamp/features/album/domain/entities/album_photo.dart';

class AlbumPhotoModel extends AlbumPhoto {
  const AlbumPhotoModel({
    required super.albumPhotoId,
    required super.albumId,
    required super.photo,
    required super.caption,
  });

  factory AlbumPhotoModel.fromJson(Map<String, dynamic> json) {
    return AlbumPhotoModel(
      albumPhotoId: json['albumPhotoId'],
      albumId: json['albumId'],
      photo: json['photo'],
      caption: json['caption'],
    );
  }

  Map<String, dynamic> toJson() => {
    'albumPhotoId': albumPhotoId,
    'albumId': albumId,
    'photo': photo,
    'caption': caption,
  };
}
