import 'package:summercamp/features/camper/data/models/health_record_model.dart';
import 'package:summercamp/features/camper/domain/entities/camper.dart';

class CamperModel extends Camper {
  const CamperModel({
    required super.camperId,
    required super.camperName,
    required super.dob,
    required super.gender,
    super.age,
    super.healthRecord,
    super.createAt,
    super.groupId,
    super.avatar,
  });

  factory CamperModel.fromJson(Map<String, dynamic> json) {
    final healthRecordData = json['healthRecord'];
    final HealthRecordModel? healthRecord = healthRecordData != null
        ? HealthRecordModel.fromJson(healthRecordData)
        : null;

    return CamperModel(
      camperId: json['camperId'],
      camperName: json['camperName'],
      dob: json['dob'],
      gender: json['gender'],
      age: json['age'],
      healthRecord: healthRecord,
      groupId: json['groupId'],
      createAt: null,
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() => {
    'camperName': camperName,
    'dob': dob,
    'gender': gender,
    'age': age,
    'groupId': groupId,
    'avatar': avatar,
    'healthRecord': (healthRecord as HealthRecordModel?)?.toJson(),
  };
}
