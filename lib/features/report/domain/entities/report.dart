class Report {
  final int reportId;
  final int camperId;
  final String camperName;
  final int? transportScheduleId;
  final String? reportType;
  final String note;
  final String image;
  final DateTime? createAt;
  final String status;
  final int? reportedBy;
  final String? activityScheduleName;
  final int? activityScheduleId;
  final int? campId;
  final String? campName;
  final String level;

  const Report({
    required this.reportId,
    required this.camperId,
    required this.camperName,
    this.transportScheduleId,
    this.reportType,
    required this.note,
    required this.image,
    this.createAt,
    required this.status,
    this.reportedBy,
    this.activityScheduleName,
    this.activityScheduleId,
    this.campId,
    this.campName,
    required this.level,
  });
}
