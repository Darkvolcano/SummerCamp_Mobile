import 'package:summercamp/features/report/domain/entities/report.dart';

class ReportModel extends Report {
  const ReportModel({
    required super.reportId,
    required super.camperId,
    required super.note,
    required super.image,
    super.createAt,
    required super.status,
    required super.level,
    super.reportedBy,
    required super.activityId,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      reportId: json['reportId'],
      camperId: json['camperId'],
      note: json['note'],
      image: json['image'],
      createAt: DateTime.parse(json['createAt']),
      status: json['status'],
      level: json['level'],
      reportedBy: json['reportedBy'],
      activityId: json['activityId'],
    );
  }

  Map<String, dynamic> toJson() => {
    'registrationId': reportId,
    'camperId': camperId,
    'note': note,
    'image': image,
    'createAt': createAt?.toIso8601String(),
    'status': status,
    'level': level,
    'reportedBy': reportedBy,
    'activityId': activityId,
  };
}
