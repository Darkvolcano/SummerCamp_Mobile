class Activity {
  final int activityId;
  final String name;
  final String description;
  final String location;
  final String date;
  final String startTime;
  final String endTime;
  final int campId;
  final bool isLivestream;
  final String? livestreamId;

  const Activity({
    required this.activityId,
    required this.name,
    required this.description,
    required this.location,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.campId,
    this.isLivestream = false,
    this.livestreamId,
  });
}
