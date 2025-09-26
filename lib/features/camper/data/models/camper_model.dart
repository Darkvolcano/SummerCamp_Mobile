import 'package:summercamp/features/camper/domain/entities/camper.dart';

class CamperModel extends Camper {
  const CamperModel({
    required super.camperId,
    required super.fullName,
    required super.dob,
    required super.gender,
    required super.healthRecordId,
    required super.createAt,
    required super.parentId,
    super.condition,
    super.allergies,
    super.isAllergy,
    super.note,
  });

  factory CamperModel.fromJson(Map<String, dynamic> json) {
    return CamperModel(
      camperId: json['camperId'],
      fullName: json['fullName'],
      dob: json['dob'],
      gender: json['gender'],
      healthRecordId: json['healthRecordId'],
      createAt: DateTime.parse(json['createAt']),
      parentId: json['parentId'],
      condition: json['condition'],
      allergies: json['allergies'],
      isAllergy: json['isAllergy'],
      note: json['note'],
    );
  }

  Map<String, dynamic> toJson() => {
    'camperId': camperId,
    'fullName': fullName,
    'dob': dob,
    'gender': gender,
    'healthRecordId': healthRecordId,
    'createAt': createAt.toIso8601String(),
    'parentId': parentId,
    'condition': condition,
    'allergies': allergies,
    'isAllergy': isAllergy,
    'note': note,
  };
}
