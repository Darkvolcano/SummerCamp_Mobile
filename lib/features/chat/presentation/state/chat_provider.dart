import 'package:flutter/material.dart';
import 'package:summercamp/features/chat/data/models/chat_model.dart';
import 'package:summercamp/features/chat/data/services/socket_service.dart';
import 'package:summercamp/features/chat/domain/entities/chat.dart';
import 'package:summercamp/features/chat/domain/use_cases/get_messages.dart';

class ChatProvider with ChangeNotifier {
  final GetMessages getMessagesUseCase;
  final SocketService socketService;

  ChatProvider(this.getMessagesUseCase, this.socketService);

  List<Chat> _messages = [];
  List<Chat> get camps => _messages;

  bool _loading = false;
  bool get loading => _loading;

  Future<void> loadChats() async {
    _loading = true;
    notifyListeners();

    _messages = await getMessagesUseCase();
    _loading = false;
    notifyListeners();
  }

  // Kết nối socket và listen sự kiện message
  void connectSocket(String token) {
    socketService.connect(token);

    socketService.onMessage.listen((ChatModel msg) {
      _messages.add(msg);
      notifyListeners();
    });

    socketService.onAck.listen((ChatModel ack) {
      // ví dụ: update trạng thái message (delivered/seen) nếu cần
    });
  }

  // Gửi message qua socket
  void sendMessage(int receiverId, String content) {
    try {
      socketService.sendMessage(receiverId, content);
      // Optionally, thêm message local ngay lập tức (tránh delay)
      final tempMsg = ChatModel(
        id: DateTime.now().millisecondsSinceEpoch, // fake id tạm
        senderId: -1, // sẽ thay bằng current user id
        receiverId: receiverId,
        content: content,
        createAt: DateTime.now(),
      );
      _messages.add(tempMsg);
      notifyListeners();
    } catch (e) {
      // handle lỗi socket
      debugPrint("Send message error: $e");
    }
  }

  // Ngắt kết nối socket
  void disconnectSocket() {
    socketService.disconnect();
  }

  void disposeProvider() {
    socketService.dispose();
  }
}
