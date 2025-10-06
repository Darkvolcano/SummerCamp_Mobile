class Camper {
  final int camperId;
  final String fullName;
  final String dob;
  final String gender;
  final int healthRecordId;
  final DateTime createAt;
  final int parentId;
  final String avatar;
  final String? condition;
  final String? allergies;
  final bool? isAllergy;
  final String? note;

  const Camper({
    required this.camperId,
    required this.fullName,
    required this.dob,
    required this.gender,
    required this.healthRecordId,
    required this.createAt,
    required this.parentId,
    required this.avatar,
    this.condition,
    this.allergies,
    this.isAllergy,
    this.note,
  });
}
