import 'package:summercamp/features/chat/domain/entities/chat.dart';

class ChatModel extends Chat {
  const ChatModel({
    required super.id,
    super.chatRoomId,
    required super.senderId,
    super.receiverId,
    required super.content,
    required super.createAt,
    super.sender,
    super.receiver,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'],
      chatRoomId: json['chatRoomId'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      content: json['content'],
      createAt: DateTime.parse(json['createAt']),
      sender: json['sender'],
      receiver: json['receiver'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'chatRoomId': chatRoomId,
    'senderId': senderId,
    'receiverId': receiverId,
    'content': content,
    'createAt': createAt.toIso8601String(),
    'sender': sender,
    'receiver': receiver,
  };
}
