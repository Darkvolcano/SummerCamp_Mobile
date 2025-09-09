class CamperModel {
  final String id;
  final String firstName;
  final String lastName;

  CamperModel({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  factory CamperModel.fromJson(Map<String, dynamic> json) {
    return CamperModel(
      id: json['camperId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }
}
