import 'package:summercamp/features/report/domain/entities/report.dart';

class ReportModel extends Report {
  const ReportModel({
    required super.reportId,
    required super.camperId,
    required super.camperName,
    super.transportScheduleId,
    super.reportType,
    required super.note,
    required super.image,
    super.createAt,
    required super.status,
    super.reportedBy,
    super.activityScheduleName,
    super.activityScheduleId,
    super.campId,
    super.campName,
    required super.level,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      reportId: json['reportId'] ?? 0,
      camperId: json['camperId'] ?? 0,
      camperName: json['camperName'],
      transportScheduleId: json['transportScheduleId'],
      reportType: json['reportType'],
      note: json['note'] ?? '',
      image: json['image'] ?? '',
      createAt: json['createAt'] != null
          ? DateTime.parse(json['createAt'])
          : null,
      status: json['status'] ?? '',
      reportedBy: json['reportedBy'],
      activityScheduleName: json['activityScheduleName'] ?? '',
      activityScheduleId: json['activityScheduleId'],
      campId: json['campId'],
      campName: json['campName'] ?? '',
      level: json['level'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'reportId': reportId,
    'camperId': camperId,
    'camperName': camperName,
    'transportScheduleId': transportScheduleId,
    'reportType': reportType,
    'note': note,
    'image': image,
    'createAt': createAt?.toIso8601String(),
    'status': status,
    'reportedBy': reportedBy,
    'activityScheduleName': activityScheduleName,
    'activityScheduleId': activityScheduleId,
    'campId': campId,
    'campName': campName,
    'level': level,
  };
}
