class Activity {
  final int activityId;
  final String name;

  const Activity({required this.activityId, required this.name});

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      activityId: json['activityId'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'activityId': activityId, 'name': name};
  }
}
