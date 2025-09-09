class Camper {
  final int id;
  final String fullName;
  final String dob;
  final String gender;
  final DateTime createAt;
  final int parentId;

  const Camper({
    required this.id,
    required this.fullName,
    required this.dob,
    required this.gender,
    required this.createAt,
    required this.parentId,
  });
}
