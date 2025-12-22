import '../../domain/entities/chat_room.dart';

class ChatRoomModel extends ChatRoom {
  const ChatRoomModel({
    required super.chatRoomId,
    required super.name,
    required super.type,
    super.lastMessage,
    super.lastMessageTime,
    super.avatarUrl,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
      chatRoomId: json['chatRoomId'] ?? 0,
      name: json['name'] ?? '',
      type: json['type'] ?? 0,
      lastMessage: json['lastMessage'],
      lastMessageTime: json['lastMessageTime'] != null
          ? DateTime.tryParse(json['lastMessageTime'])
          : null,
      avatarUrl: json['avatarUrl'],
    );
  }
}
