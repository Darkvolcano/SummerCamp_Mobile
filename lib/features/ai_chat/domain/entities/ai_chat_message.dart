class AiChatMessage {
  final String role;
  final String content;

  AiChatMessage({required this.role, required this.content});

  factory AiChatMessage.fromJson(Map<String, dynamic> json) {
    return AiChatMessage(
      role: json['role'] as String,
      content: json['content'] as String,
    );
  }
}
