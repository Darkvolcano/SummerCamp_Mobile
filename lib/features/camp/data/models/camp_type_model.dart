import 'package:summercamp/features/camp/domain/entities/camp_type.dart';

class CampTypeModel extends CampType {
  const CampTypeModel({
    required super.campTypeId,
    required super.name,
    required super.description,
    required super.isActive,
  });

  factory CampTypeModel.fromJson(Map<String, dynamic> json) {
    return CampTypeModel(
      campTypeId: json['campTypeId'],
      name: json['name'],
      description: json['description'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() => {
    'campTypeId': campTypeId,
    'name': name,
    'description': description,
    'isActive': isActive,
  };
}
