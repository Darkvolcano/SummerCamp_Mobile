import 'package:summercamp/features/camper/domain/entities/camper_group.dart';

class CamperGroupModel extends CamperGroup {
  const CamperGroupModel({
    required super.camperGroupId,
    required super.camperName,
    required super.groupName,
    required super.status,
  });

  factory CamperGroupModel.fromJson(Map<String, dynamic> json) {
    return CamperGroupModel(
      camperGroupId: json['camperGroupId'] ?? 0,
      camperName: CamperInfoModel.fromJson(json['camperName'] ?? {}),
      groupName: GroupInfoModel.fromJson(json['groupName'] ?? {}),
      status: json['status'] ?? 'Unknown',
    );
  }
}

class CamperInfoModel extends CamperInfo {
  const CamperInfoModel({required super.camperId, required super.camperName});

  factory CamperInfoModel.fromJson(Map<String, dynamic> json) {
    return CamperInfoModel(
      camperId: json['camperId'] ?? 0,
      camperName: json['camperName'] ?? '',
    );
  }
}

class GroupInfoModel extends GroupInfo {
  const GroupInfoModel({
    required super.groupId,
    required super.groupName,
    required super.currentSize,
  });

  factory GroupInfoModel.fromJson(Map<String, dynamic> json) {
    return GroupInfoModel(
      groupId: json['groupId'] ?? 0,
      groupName: json['groupName'] ?? '',
      currentSize: json['currentSize'] ?? 0,
    );
  }
}
