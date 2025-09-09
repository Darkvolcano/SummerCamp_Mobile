import '../../domain/entities/camp.dart';

class CampModel extends Camp {
  const CampModel({
    required super.id,
    required super.name,
    required super.description,
    required super.place,
    required super.startDate,
    required super.endDate,
  });

  factory CampModel.fromJson(Map<String, dynamic> json) {
    return CampModel(
      id: json['campId'],
      name: json['name'],
      description: json['description'],
      place: json['place'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
    );
  }

  Map<String, dynamic> toJson() => {
    'campId': id,
    'name': name,
    'description': description,
    'place': place,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
  };
}
