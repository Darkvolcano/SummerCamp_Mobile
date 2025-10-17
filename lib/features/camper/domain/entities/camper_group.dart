import 'package:summercamp/features/camper/domain/entities/camper.dart';

class CamperGroup {
  final int camperGroupId;
  final String groupName;
  final String description;
  final int maxSize;
  final int supervisorId;
  final int campId;
  final Camper? campers;

  const CamperGroup({
    required this.camperGroupId,
    required this.groupName,
    required this.description,
    required this.maxSize,
    required this.supervisorId,
    required this.campId,
    this.campers,
  });
}
