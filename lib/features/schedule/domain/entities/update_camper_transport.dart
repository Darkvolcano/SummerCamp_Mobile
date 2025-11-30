class UpdateCamperTransport {
  final int camperTransportId;
  final int camperId;
  final String note;

  const UpdateCamperTransport({
    required this.camperTransportId,
    required this.camperId,
    this.note = "",
  });

  Map<String, dynamic> toJson() {
    return {
      'camperTransportId': camperTransportId,
      'camperId': camperId,
      'note': note,
    };
  }
}
