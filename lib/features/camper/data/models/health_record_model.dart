import 'package:summercamp/features/camper/domain/entities/health_record.dart';

class HealthRecordModel extends HealthRecord {
  const HealthRecordModel({
    required super.id,
    required super.condition,
    required super.allergies,
    required super.note,
    required super.createAt,
    required super.camperId,
  });

  factory HealthRecordModel.fromJson(Map<String, dynamic> json) {
    return HealthRecordModel(
      id: json['healthRecordId'],
      condition: json['condition'],
      allergies: json['allergies'],
      note: json['note'],
      createAt: DateTime.parse(json['createAt']),
      camperId: json['camperId'],
    );
  }

  Map<String, dynamic> toJson() => {
    'healthRecordId': id,
    'condition': condition,
    'allergies': allergies,
    'note': note,
    'createAt': createAt.toIso8601String(),
    'camperId': camperId,
  };
}
