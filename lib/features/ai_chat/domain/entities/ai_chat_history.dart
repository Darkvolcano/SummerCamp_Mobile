class AiChatHistory {
  final int conversationId;
  final String title;

  AiChatHistory({required this.conversationId, required this.title});

  factory AiChatHistory.fromJson(Map<String, dynamic> json) {
    return AiChatHistory(
      conversationId: json['conversationId'] as int,
      title: json['title'] as String,
    );
  }
}
