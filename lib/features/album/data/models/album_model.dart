import 'package:summercamp/features/album/domain/entities/album.dart';

class AlbumModel extends Album {
  const AlbumModel({
    required super.albumId,
    required super.campId,
    required super.date,
    required super.title,
    required super.description,
    required super.photoCount,
  });

  factory AlbumModel.fromJson(Map<String, dynamic> json) {
    return AlbumModel(
      albumId: json['albumId'],
      campId: json['campId'],
      date: json['date'],
      title: json['title'],
      description: json['description'],
      photoCount: json['photoCount'],
    );
  }

  Map<String, dynamic> toJson() => {
    'albumId': albumId,
    'campId': campId,
    'date': date,
    'title': title,
    'description': description,
    'photoCount': photoCount,
  };
}
