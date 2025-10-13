import 'package:summercamp/features/camp/domain/entities/camp.dart';

class CampModel extends Camp {
  const CampModel({
    required super.campId,
    required super.name,
    required super.description,
    required super.place,
    required super.startDate,
    required super.endDate,
    super.image,
    super.maxParticipants,
    super.minParticipants,
    required super.price,
    required super.status,
    required super.campTypeId,
  });

  factory CampModel.fromJson(Map<String, dynamic> json) {
    String safeString(dynamic value) {
      if (value == null) return '';
      return value.toString();
    }

    int safeInt(dynamic value) {
      if (value is int) return value;
      if (value is double) return value.round();
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    int safePrice(dynamic value) {
      if (value is int) return value;
      if (value is double) return value.round();
      return 0;
    }

    return CampModel(
      campId: safeInt(json['campId']),
      name: safeString(json['name']),
      description: safeString(json['description']),
      place: safeString(json['place']),

      startDate: safeString(json['startDate']),
      endDate: safeString(json['endDate']),

      image: safeString(json['image']),
      minParticipants: safeInt(json['minParticipants']),
      maxParticipants: safeInt(json['maxParticipants']),

      price: safePrice(json['price']),
      status: safeString(json['status']),
      campTypeId: safeInt(json['campTypeId']),
    );
  }

  Map<String, dynamic> toJson() => {
    'campId': campId,
    'name': name,
    'description': description,
    'place': place,
    'startDate': startDate,
    'endDate': endDate,
    'image': image,
    'maxParticipants': maxParticipants,
    'minParticipants': minParticipants,
    'price': price,
    'status': status,
    'campTypeId': campTypeId,
  };
}
