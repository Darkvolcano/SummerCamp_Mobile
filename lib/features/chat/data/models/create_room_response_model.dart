import '../../domain/entities/create_room_result.dart';

class CreateRoomResponseModel extends CreateRoomResult {
  const CreateRoomResponseModel({
    required super.chatRoomId,
    required super.isNewRoom,
    required super.recipientName,
    required super.recipientAvatar,
    required super.recipientUserId,
  });

  factory CreateRoomResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateRoomResponseModel(
      chatRoomId: json['chatRoomId'] ?? 0,
      isNewRoom: json['isNewRoom'] ?? false,
      recipientName: json['recipientName'] ?? '',
      recipientAvatar: json['recipientAvatar'] ?? '',
      recipientUserId: json['recipientUserId'] ?? 0,
    );
  }
}
