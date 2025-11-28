class RegistrationCamper {
  final int camperId;
  final String camperName;

  const RegistrationCamper({required this.camperId, required this.camperName});

  factory RegistrationCamper.fromJson(Map<String, dynamic> json) {
    return RegistrationCamper(
      camperId: json['camperId'],
      camperName: json['camperName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'camperId': camperId, 'camperName': camperName};
  }
}
