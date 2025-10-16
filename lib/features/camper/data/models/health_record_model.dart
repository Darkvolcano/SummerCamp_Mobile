import 'package:summercamp/features/camper/domain/entities/health_record.dart';

class HealthRecordModel extends HealthRecord {
  const HealthRecordModel({
    super.healthRecordId,
    super.condition,
    super.allergies,
    super.note,
    super.createAt,
    super.camperId,
    super.isAllergy,
  });

  factory HealthRecordModel.fromJson(Map<String, dynamic> json) {
    return HealthRecordModel(
      healthRecordId: json['healthRecordId'],
      camperId: json['camperId'],
      condition: json['condition'],
      allergies: json['allergies'],
      note: json['note'],
      createAt: json['createAt'] != null
          ? DateTime.parse(json['createAt'])
          : null,
      isAllergy: json['isAllergy'],
    );
  }

  Map<String, dynamic> toJson() => {
    'condition': condition,
    'allergies': allergies,
    'note': note,
    'isAllergy': isAllergy,
  };
}
