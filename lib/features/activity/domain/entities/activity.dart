class Activity {
  final int activityId;
  final String name;
  final String description;
  final String location;
  final DateTime startTime;
  final DateTime endTime;
  final int campId;
  final bool isLivestream;
  final int? roomId; // thay bằng String
  final int? staffId;
  final String activityType;

  const Activity({
    required this.activityId,
    required this.name,
    required this.description,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.campId,
    this.isLivestream = false,
    this.roomId,
    this.staffId,
    required this.activityType,
  });
}
