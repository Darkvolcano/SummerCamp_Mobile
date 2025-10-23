class RegistrationOptionalChoice {
  final int camperId;
  final String activityName;
  final String status;

  const RegistrationOptionalChoice({
    required this.camperId,
    required this.activityName,
    required this.status,
  });

  factory RegistrationOptionalChoice.fromJson(Map<String, dynamic> json) {
    return RegistrationOptionalChoice(
      camperId: json['camperId'],
      activityName: json['activityName'],
      status: json['status'],
    );
  }
}
