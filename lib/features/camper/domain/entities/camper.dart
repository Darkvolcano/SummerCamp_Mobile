class Camper {
  final int camperId;
  final String fullName;
  final String dob;
  final String gender;
  final int healthRecordId;
  final DateTime createAt;
  final int parentId;

  const Camper({
    required this.camperId,
    required this.fullName,
    required this.dob,
    required this.gender,
    required this.healthRecordId,
    required this.createAt,
    required this.parentId,
  });
}
