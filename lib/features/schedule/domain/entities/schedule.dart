import 'package:summercamp/core/enum/camp_status.enum.dart';
import 'package:summercamp/features/camp/domain/entities/camp_camp_type.dart';

class Schedule {
  final int campId;
  final String name;
  final String description;
  final String place;
  final String startDate;
  final String endDate;
  final String image;
  final int maxParticipants;
  final int minParticipants;
  final int? minAge;
  final int? maxAge;
  final double price;
  final CampStatus status;
  final CampCampType? campType;

  const Schedule({
    required this.campId,
    required this.name,
    required this.description,
    required this.place,
    required this.startDate,
    required this.endDate,
    this.image = "",
    this.maxParticipants = 0,
    this.minParticipants = 0,
    this.minAge,
    this.maxAge,
    required this.price,
    required this.status,
    this.campType,
  });
}
