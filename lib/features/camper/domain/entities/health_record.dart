class HealthRecord {
  final int id;
  final String condition;
  final String allergies;
  final String note;
  final DateTime createAt;
  final int camperId;

  const HealthRecord({
    required this.id,
    required this.condition,
    required this.allergies,
    required this.note,
    required this.createAt,
    required this.camperId,
  });
}
