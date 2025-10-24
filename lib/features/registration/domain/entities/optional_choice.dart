class OptionalChoice {
  final int camperId;
  final int activityScheduleId;

  const OptionalChoice({
    required this.camperId,
    required this.activityScheduleId,
  });

  Map<String, dynamic> toJson() {
    return {'camperId': camperId, 'activityScheduleId': activityScheduleId};
  }
}
