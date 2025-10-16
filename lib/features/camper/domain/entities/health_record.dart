class HealthRecord {
  final int? healthRecordId;
  final String? condition;
  final String? allergies;
  final String? note;
  final DateTime? createAt;
  final int? camperId;
  final bool? isAllergy;

  const HealthRecord({
    this.healthRecordId,
    this.condition,
    this.allergies,
    this.note,
    this.createAt,
    this.camperId,
    this.isAllergy,
  });
}
