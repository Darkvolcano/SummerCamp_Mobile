class UpdateAttendance {
  final int attendanceLogId;
  final String participantStatus;
  final String note;

  const UpdateAttendance({
    required this.attendanceLogId,
    required this.participantStatus,
    this.note = "",
  });

  Map<String, dynamic> toJson() {
    return {
      'attendanceLogId': attendanceLogId,
      'participantStatus': participantStatus,
      'note': note,
    };
  }
}
