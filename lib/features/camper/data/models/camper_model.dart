import 'package:summercamp/features/camper/data/models/health_record_model.dart';
import 'package:summercamp/features/camper/domain/entities/camper.dart';

class CamperModel extends Camper {
  const CamperModel({
    required super.camperId,
    required super.fullName,
    required super.dob,
    required super.gender,
    super.healthRecord,
    super.createAt,
    super.groupId,
    super.avatar,
  });

  factory CamperModel.fromJson(Map<String, dynamic> json) {
    // Xử lý object healthRecord lồng nhau
    final healthRecordData = json['healthRecord'];
    final HealthRecordModel? healthRecord = healthRecordData != null
        ? HealthRecordModel.fromJson(healthRecordData)
        : null;

    return CamperModel(
      camperId: json['camperId'],
      fullName: json['camperName'],
      dob: json['dob'],
      gender: json['gender'],
      healthRecord: healthRecord,
      groupId: json['groupId'],
      createAt: null,
      avatar: null,
    );
  }

  Map<String, dynamic> toJson() => {
    'camperName': fullName,
    'dob': dob,
    'gender': gender,
    'groupId': groupId,
    'healthRecords': (healthRecord as HealthRecordModel?)?.toJson(),
  };
}
