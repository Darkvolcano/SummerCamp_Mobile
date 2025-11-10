class Activity {
  final String name;
  final String activityType;

  const Activity({required this.name, required this.activityType});

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(name: json['name'], activityType: json['activityType']);
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'activityType': activityType};
  }
}
