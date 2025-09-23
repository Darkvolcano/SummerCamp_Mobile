class HealthRecord {
  final int healthRecordId;
  final String condition;
  final String allergies;
  final String note;
  final DateTime createAt;
  final int camperId;

  const HealthRecord({
    required this.healthRecordId,
    required this.condition,
    required this.allergies,
    required this.note,
    required this.createAt,
    required this.camperId,
  });
}
