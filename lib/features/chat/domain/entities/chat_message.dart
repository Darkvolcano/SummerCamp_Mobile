class ChatMessage {
  final int messageId;
  final int chatRoomId;
  final int senderId;
  final String senderName;
  final String avatar;
  final String content;
  final DateTime sentAt;

  const ChatMessage({
    required this.messageId,
    required this.chatRoomId,
    required this.senderId,
    required this.senderName,
    required this.avatar,
    required this.content,
    required this.sentAt,
  });
}
