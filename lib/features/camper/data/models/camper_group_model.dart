import 'package:summercamp/features/camper/data/models/camper_model.dart';
import 'package:summercamp/features/camper/domain/entities/camper_group.dart';

class CamperGroupModel extends CamperGroup {
  const CamperGroupModel({
    required super.camperGroupId,
    required super.groupName,
    required super.description,
    required super.maxSize,
    required super.supervisorId,
    required super.campId,
    super.campers,
  });

  factory CamperGroupModel.fromJson(Map<String, dynamic> json) {
    final camperData = json['campers'];
    final CamperModel? campers = camperData != null
        ? CamperModel.fromJson(camperData)
        : null;

    return CamperGroupModel(
      camperGroupId: json['camperGroupId'],
      groupName: json['groupName'],
      description: json['description'],
      maxSize: json['maxSize'],
      supervisorId: json['supervisorId'],
      campId: json['campId'],
      campers: campers,
    );
  }

  Map<String, dynamic> toJson() => {
    'camperGroupId': camperGroupId,
    'groupName': groupName,
    'description': description,
    'maxSize': maxSize,
    'supervisorId': supervisorId,
    'campId': campId,
    'campers': (campers as CamperModel?)?.toJson(),
  };
}
