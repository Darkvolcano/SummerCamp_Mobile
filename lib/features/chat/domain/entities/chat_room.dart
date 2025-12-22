class ChatRoom {
  final int chatRoomId;
  final String name;
  final int type; // 0 = private, 1 = group
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final String? avatarUrl;

  const ChatRoom({
    required this.chatRoomId,
    required this.name,
    required this.type,
    this.lastMessage,
    this.lastMessageTime,
    this.avatarUrl,
  });
}
