import 'package:summercamp/features/registration/domain/entities/registration_camper_response.dart';

class RegistrationCamperResponseModel extends RegistrationCamperResponse {
  const RegistrationCamperResponseModel({
    required super.registrationId,
    required super.camperId,
    super.camperGroup,
    required super.status,
    required super.requestTransport,
    required super.camp,
  });

  factory RegistrationCamperResponseModel.fromJson(Map<String, dynamic> json) {
    return RegistrationCamperResponseModel(
      registrationId: json['registrationId'] ?? 0,
      camperId: json['camperId'] ?? 0,
      camperGroup: json['camperGroup'] != null
          ? CamperGroupInfoModel.fromJson(json['camperGroup'])
          : null,
      status: json['status'] ?? '',
      requestTransport: json['requestTransport'] ?? false,
      camp: CampInfoModel.fromJson(json['camp'] ?? {}),
    );
  }
}

// --- Các Model phụ trợ ---

class CamperGroupInfoModel extends CamperGroupInfo {
  CamperGroupInfoModel({required super.camperName, required super.groupName});
  factory CamperGroupInfoModel.fromJson(Map<String, dynamic> json) {
    return CamperGroupInfoModel(
      camperName: CamperDetailModel.fromJson(json['camperName'] ?? {}),
      groupName: GroupDetailModel.fromJson(json['groupName'] ?? {}),
    );
  }
}

class CamperDetailModel extends CamperDetail {
  CamperDetailModel({required super.camperId, required super.camperName});
  factory CamperDetailModel.fromJson(Map<String, dynamic> json) {
    return CamperDetailModel(
      camperId: json['camperId'] ?? 0,
      camperName: json['camperName'] ?? '',
    );
  }
}

class GroupDetailModel extends GroupDetail {
  GroupDetailModel({
    required super.groupId,
    required super.groupName,
    required super.currentSize,
  });
  factory GroupDetailModel.fromJson(Map<String, dynamic> json) {
    return GroupDetailModel(
      groupId: json['groupId'] ?? 0,
      groupName: json['groupName'] ?? '',
      currentSize: json['currentSize'] ?? 0,
    );
  }
}

class CampInfoModel extends CampInfo {
  CampInfoModel({
    required super.campId,
    required super.name,
    required super.status,
    required super.startDate,
    required super.endDate,
  });
  factory CampInfoModel.fromJson(Map<String, dynamic> json) {
    return CampInfoModel(
      campId: json['campId'] ?? 0,
      name: json['name'] ?? '',
      status: json['status'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
    );
  }
}
