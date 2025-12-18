import 'package:summercamp/features/report/domain/entities/report.dart';

class ReportModel extends Report {
  const ReportModel({
    required super.reportId,
    required super.camperId,
    super.transportScheduleId,
    super.reportType,
    required super.note,
    required super.image,
    super.createAt,
    required super.status,
    super.reportedBy,
    super.activityScheduleId,
    required super.level,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      reportId: json['reportId'] ?? 0,
      camperId: json['camperId'] ?? 0,
      transportScheduleId: json['transportScheduleId'],
      reportType: json['reportType'],
      note: json['note'] ?? '',
      image: json['image'] ?? '',
      createAt: json['createAt'] != null
          ? DateTime.parse(json['createAt'])
          : null,
      status: json['status'] ?? '',
      reportedBy: json['reportedBy'],
      activityScheduleId: json['activityScheduleId'],
      level: json['level'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'reportId': reportId,
    'camperId': camperId,
    'transportScheduleId': transportScheduleId,
    'reportType': reportType,
    'note': note,
    'image': image,
    'createAt': createAt?.toIso8601String(),
    'status': status,
    'reportedBy': reportedBy,
    'activityScheduleId': activityScheduleId,
    'level': level,
  };
}
