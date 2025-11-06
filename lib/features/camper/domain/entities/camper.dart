import 'package:summercamp/features/camper/domain/entities/health_record.dart';

class Camper {
  final int camperId;
  final String camperName;
  final String dob;
  final String gender;
  final int? age;
  final DateTime? createAt;
  final int? groupId;
  final String? avatar;
  final HealthRecord? healthRecord;

  const Camper({
    required this.camperId,
    required this.camperName,
    required this.dob,
    required this.gender,
    this.age,
    this.createAt,
    this.groupId,
    this.avatar,
    this.healthRecord,
  });
}
