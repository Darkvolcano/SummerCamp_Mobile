import 'package:summercamp/features/camper/domain/entities/group.dart';

class GroupModel extends Group {
  const GroupModel({
    required super.campId,
    required super.campName,
    required super.groupId,
    required super.groupName,
    required super.minAge,
    required super.maxAge,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      campId: json['campId'] ?? 0,
      campName: json['campName'] ?? '',
      groupId: json['groupId'] ?? 0,
      groupName: json['groupName'] ?? '',
      minAge: json['minAge'] ?? 0,
      maxAge: json['maxAge'] ?? 0,
    );
  }
}
