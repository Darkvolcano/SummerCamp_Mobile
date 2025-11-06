class AiChatMessage {
  final int? messageId;
  final String role;
  final String content;
  final DateTime? sentAt;

  AiChatMessage({
    this.messageId,
    required this.role,
    required this.content,
    this.sentAt,
  });

  factory AiChatMessage.fromJson(Map<String, dynamic> json) {
    return AiChatMessage(
      messageId: json['messageId'],
      role: json['role'],
      content: json['content'],
      sentAt: json['sentAt'] != null
          ? DateTime.parse(json['sentAt'] as String)
          : null,
    );
  }
}
