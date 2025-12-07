class RegistrationCamperResponse {
  final int registrationId;
  final int camperId;
  final CamperGroupInfo? camperGroup;
  final String status;
  final bool requestTransport;
  final CampInfo camp;

  const RegistrationCamperResponse({
    required this.registrationId,
    required this.camperId,
    this.camperGroup,
    required this.status,
    required this.requestTransport,
    required this.camp,
  });
}

// Các class phụ trợ cũng nên là Entity hoặc POJO đơn giản
class CamperGroupInfo {
  final CamperDetail camperName;
  final GroupDetail groupName;
  CamperGroupInfo({required this.camperName, required this.groupName});
}

class CamperDetail {
  final int camperId;
  final String camperName;
  CamperDetail({required this.camperId, required this.camperName});
}

class GroupDetail {
  final int groupId;
  final String groupName;
  final int currentSize;
  GroupDetail({
    required this.groupId,
    required this.groupName,
    required this.currentSize,
  });
}

class CampInfo {
  final int campId;
  final String name;
  final String status;
  final String startDate;
  final String endDate;
  CampInfo({
    required this.campId,
    required this.name,
    required this.status,
    required this.startDate,
    required this.endDate,
  });
}
