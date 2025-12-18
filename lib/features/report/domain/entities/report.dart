class Report {
  final int reportId;
  final int camperId;
  final int? transportScheduleId;
  final String? reportType;
  final String note;
  final String image;
  final DateTime? createAt;
  final String status;
  final int? reportedBy;
  final int? activityScheduleId;
  final String level;

  const Report({
    required this.reportId,
    required this.camperId,
    this.transportScheduleId,
    this.reportType,
    required this.note,
    required this.image,
    this.createAt,
    required this.status,
    this.reportedBy,
    this.activityScheduleId,
    required this.level,
  });
}
