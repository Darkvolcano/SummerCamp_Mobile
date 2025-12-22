import '../../domain/entities/chat_message.dart';

class ChatMessageModel extends ChatMessage {
  const ChatMessageModel({
    required super.messageId,
    required super.chatRoomId,
    required super.senderId,
    required super.senderName,
    required super.avatar,
    required super.content,
    required super.sentAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      messageId: json['messageId'] ?? 0,
      chatRoomId: json['chatRoomId'] ?? 0,
      senderId: json['senderId'] ?? 0,
      senderName: json['senderName'] ?? '',
      avatar: json['avatar'] ?? '',
      content: json['content'] ?? '',
      sentAt: DateTime.tryParse(json['sentAt'] ?? '') ?? DateTime.now(),
    );
  }
}
