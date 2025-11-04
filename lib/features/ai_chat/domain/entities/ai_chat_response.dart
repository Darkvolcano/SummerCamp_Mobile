class AiChatResponse {
  final String textResponse;
  final int conversationId;

  AiChatResponse({required this.textResponse, required this.conversationId});

  factory AiChatResponse.fromJson(Map<String, dynamic> json) {
    return AiChatResponse(
      textResponse: json['textResponse'] as String,
      conversationId: json['conversationId'] as int,
    );
  }
}
