import 'package:flutter/foundation.dart';
import 'package:summercamp/features/ai_chat/domain/use_cases/get_chat_history.dart';
import 'package:summercamp/features/ai_chat/domain/use_cases/get_conversation.dart';
import 'package:summercamp/features/ai_chat/domain/use_cases/send_chat_message.dart';

class AIChatProvider with ChangeNotifier {
  final SendChatMessage sendChatMessageUseCase;
  final GetChatHistory getChatHistoryUseCase;
  final GetConversation getConversationUseCase;

  AIChatProvider({
    required this.sendChatMessageUseCase,
    required this.getChatHistoryUseCase,
    required this.getConversationUseCase,
  });

  int? _currentConversationId;

  final List<Map<String, dynamic>> _messages = [];

  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadHistory() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final history = await getChatHistoryUseCase();

      if (history.isEmpty) {
        _messages.clear();
        // _messages.add({
        //   "text": "Xin chào! Tôi là trợ lý AI, tôi có thể giúp gì cho bạn?",
        //   "isMe": false,
        // });
        _currentConversationId = null;
      } else {
        final lastConversation = history.first;
        _currentConversationId = lastConversation.conversationId;
        await loadConversation(_currentConversationId!);
      }
    } catch (e) {
      _error = e.toString();
      _messages.add({
        "text": "Lỗi khi tải lịch sử chat. Vui lòng thử lại.",
        "isMe": false,
      });
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadConversation(int conversationId) async {
    try {
      final messageList = await getConversationUseCase(conversationId);
      _messages.clear();

      for (var msg in messageList) {
        _messages.add({"text": msg.content, "isMe": msg.role.trim() == "user"});
      }

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _messages.add({
        "text": "Lỗi khi tải nội dung chat. Vui lòng thử lại.",
        "isMe": false,
      });
    }
  }

  Future<void> sendMessage(String content) async {
    _messages.add({"text": content, "isMe": true});
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final aiReply = await sendChatMessageUseCase(
        _currentConversationId,
        content,
      );

      _messages.add({"text": aiReply.textResponse, "isMe": false});
      _currentConversationId = aiReply.conversationId;
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
