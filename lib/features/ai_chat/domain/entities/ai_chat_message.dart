class AiChatMessage {
  final String role;
  final String content;
  final DateTime? sentAt;

  AiChatMessage({required this.role, required this.content, this.sentAt});

  factory AiChatMessage.fromJson(Map<String, dynamic> json) {
    return AiChatMessage(
      role: json['role'],
      content: json['content'],
      sentAt: json['sentAt'],
    );
  }
}
