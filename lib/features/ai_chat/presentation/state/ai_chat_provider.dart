import 'package:flutter/foundation.dart';
import 'package:summercamp/features/ai_chat/domain/use_cases/send_chat_message.dart';

class AIChatProvider with ChangeNotifier {
  final SendChatMessage sendChatMessageUseCase;

  AIChatProvider(this.sendChatMessageUseCase);

  final List<Map<String, dynamic>> _messages = [
    {
      "text": "Xin chào! Tôi là trợ lý AI, tôi có thể giúp gì cho bạn?",
      "isMe": false,
    },
  ];
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> sendMessage(String content) async {
    _messages.add({"text": content, "isMe": true});
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final aiReply = await sendChatMessageUseCase(content);

      _messages.add({"text": aiReply, "isMe": false});
    } catch (e) {
      _error = e.toString();
      _messages.add({
        "text": "Xin lỗi, tôi gặp chút sự cố. Vui lòng thử lại sau!",
        "isMe": false,
      });
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
