class TransportScheduleRoute {
  final int routeId;
  final String routeName;

  const TransportScheduleRoute({
    required this.routeId,
    required this.routeName,
  });

  factory TransportScheduleRoute.fromJson(Map<String, dynamic> json) {
    return TransportScheduleRoute(
      routeId: json['routeId'],
      routeName: json['routeName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'routeId': routeId, 'routeName': routeName};
  }
}
