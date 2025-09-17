class Camp {
  final String id;
  final String name;
  final String description;
  final String place;
  final DateTime startDate;
  final DateTime endDate;
  final String image;
  final int maxParticipants;
  final int price;
  final String status;
  final int campTypeId;

  const Camp({
    required this.id,
    required this.name,
    required this.description,
    required this.place,
    required this.startDate,
    required this.endDate,
    required this.image,
    required this.maxParticipants,
    required this.price,
    required this.status,
    required this.campTypeId,
  });
}
