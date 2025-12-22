class SendMessageRequestModel {
  final int chatRoomId;
  final String content;

  SendMessageRequestModel({required this.chatRoomId, required this.content});

  Map<String, dynamic> toJson() => {
    'chatRoomId': chatRoomId,
    'content': content,
  };
}

class CreatePrivateRoomRequestModel {
  final int recipientUserId;

  CreatePrivateRoomRequestModel({required this.recipientUserId});

  Map<String, dynamic> toJson() => {'recipientUserId': recipientUserId};
}
