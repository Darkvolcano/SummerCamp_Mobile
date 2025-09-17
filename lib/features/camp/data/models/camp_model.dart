import 'package:summercamp/features/camp/domain/entities/camp.dart';

class CampModel extends Camp {
  const CampModel({
    required super.id,
    required super.name,
    required super.description,
    required super.place,
    required super.startDate,
    required super.endDate,
    required super.image,
    required super.maxParticipants,
    required super.price,
    required super.status,
    required super.campTypeId,
  });

  factory CampModel.fromJson(Map<String, dynamic> json) {
    return CampModel(
      id: json['campId'],
      name: json['name'],
      description: json['description'],
      place: json['place'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      image: json['image'],
      maxParticipants: json['maxParticipants'],
      price: json['price'],
      status: json['status'],
      campTypeId: json['campTypeId'],
    );
  }

  Map<String, dynamic> toJson() => {
    'campId': id,
    'name': name,
    'description': description,
    'place': place,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
    'image': image,
    'maxParticipants': maxParticipants,
    'price': price,
    'status': status,
    'campTypeId': campTypeId,
  };
}
