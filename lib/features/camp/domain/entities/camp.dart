import 'package:summercamp/core/enum/camp_status.enum.dart';
import 'package:summercamp/features/camp/domain/entities/camp_camp_type.dart';
import 'package:summercamp/features/camp/domain/entities/camp_promtion.dart';

class Camp {
  final int campId;
  final String name;
  final String description;
  final String place;
  final String startDate;
  final String endDate;
  final String image;
  final int maxParticipants;
  final int minParticipants;
  final int price;
  final CampStatus status;
  final DateTime registrationStartDate;
  final DateTime registrationEndDate;
  final CampCampType? campType;
  final CampPromotion? promotion;

  const Camp({
    required this.campId,
    required this.name,
    required this.description,
    required this.place,
    required this.startDate,
    required this.endDate,
    this.image = "",
    this.maxParticipants = 0,
    this.minParticipants = 0,
    required this.price,
    required this.status,
    required this.registrationStartDate,
    required this.registrationEndDate,
    this.campType,
    this.promotion,
  });
}
