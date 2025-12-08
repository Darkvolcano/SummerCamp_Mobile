class CamperGroup {
  final int camperGroupId;
  final CamperInfo camperName;
  final GroupInfo groupName;
  final String status;

  const CamperGroup({
    required this.camperGroupId,
    required this.camperName,
    required this.groupName,
    required this.status,
  });
}

class CamperInfo {
  final int camperId;
  final String camperName;

  const CamperInfo({required this.camperId, required this.camperName});
}

class GroupInfo {
  final int groupId;
  final String groupName;
  final int currentSize;

  const GroupInfo({
    required this.groupId,
    required this.groupName,
    required this.currentSize,
  });
}
