class Report {
  final int reportId;
  final int camperId;
  final String note;
  final String image;
  final DateTime? createAt;
  final String status;
  final String level;
  final int? reportedBy;
  final int activityId;

  const Report({
    required this.reportId,
    required this.camperId,
    required this.note,
    required this.image,
    this.createAt,
    required this.status,
    required this.level,
    this.reportedBy,
    required this.activityId,
  });
}
