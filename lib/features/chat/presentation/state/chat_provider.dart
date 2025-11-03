import 'dart:async';
import 'package:flutter/material.dart';
import 'package:summercamp/core/network/socket_client.dart';
import 'package:summercamp/features/auth/domain/entities/user.dart';
import 'package:summercamp/features/auth/presentation/state/auth_provider.dart';
import 'package:summercamp/features/chat/domain/entities/chat.dart';
import 'package:summercamp/features/chat/domain/use_cases/get_messages.dart';

class ChatProvider with ChangeNotifier {
  final GetMessages getMessagesUseCase;
  final SocketClient socketClient;
  final AuthProvider auth;

  ChatProvider(this.getMessagesUseCase, this.socketClient, this.auth);

  List<Chat> _messages = [];
  List<Chat> _chats = [];
  List<Chat> get messages => _messages;
  User? selectedUser;

  bool isSending = false;
  int? tempMessageId;
  Timer? _ackTimer;

  StreamSubscription<Chat>? _msgSub;
  StreamSubscription<Chat>? _ackSub;

  bool _loading = false;
  bool get loading => _loading;
  List<Chat> get chats => _chats;

  Future<void> init() async {
    await loadChats();

    socketClient.setToken(auth.token!);
    socketClient.connect();

    _listenSocket();
  }

  Future<void> loadChats() async {
    _loading = true;
    notifyListeners();

    _messages = await getMessagesUseCase();
    _loading = false;
    notifyListeners();
  }

  void _listenSocket() {
    _msgSub = socketClient.onMessage.listen((msg) {
      if (selectedUser != null &&
          (msg.senderId == selectedUser!.userId ||
              msg.receiverId == selectedUser!.userId)) {
        _chats.add(msg);
        _chats.sort((a, b) => a.createAt.compareTo(b.createAt));
      } else {
        _messages.insert(0, msg);
        _messages.sort((a, b) => b.createAt.compareTo(a.createAt));
      }
      notifyListeners();
    });

    _ackSub = socketClient.onAck.listen((ack) {
      if (tempMessageId != null) {
        _chats = _chats
            .map((c) => c.chatId == tempMessageId ? ack : c)
            .toList();
        _messages.insert(0, ack);
        _messages.sort((a, b) => b.createAt.compareTo(a.createAt));

        isSending = false;
        tempMessageId = null;
        _ackTimer?.cancel();
        notifyListeners();
      }
    });
  }

  void selectUser(User user) {
    selectedUser = user;
    final conv = _messages
        .where(
          (chat) =>
              (chat.receiverId == user.userId || chat.senderId == user.userId),
        )
        .toList();
    conv.sort((a, b) => a.createAt.compareTo(b.createAt));
    _chats = conv;
    notifyListeners();
  }

  void sendMessage(int receiverId, String content) {
    final tempId = DateTime.now().millisecondsSinceEpoch;
    tempMessageId = tempId;
    isSending = true;

    final tempChat = Chat(
      chatId: tempId,
      chatRoomId: null,
      senderId: auth.user!.userId!,
      receiverId: receiverId,
      content: content,
      createAt: DateTime.now(),
    );

    _chats.add(tempChat);
    notifyListeners();

    try {
      socketClient.sendMessage(receiverId, content);
    } catch (_) {
      isSending = false;
      tempMessageId = null;
      notifyListeners();
      return;
    }

    _ackTimer?.cancel();
    _ackTimer = Timer(const Duration(seconds: 1), () {
      if (isSending && tempMessageId == tempId) {
        _messages.insert(0, tempChat);
        _messages.sort((a, b) => b.createAt.compareTo(a.createAt));
        isSending = false;
        tempMessageId = null;
        notifyListeners();
      }
    });
  }

  bool _isMessageBetweenUsers(Chat message, int userId1, int userId2) {
    return (message.senderId == userId1 && message.receiverId == userId2) ||
        (message.senderId == userId2 && message.receiverId == userId1);
  }

  String _formatMessageTime(DateTime messageTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(
      messageTime.year,
      messageTime.month,
      messageTime.day,
    );
    final yesterday = today.subtract(const Duration(days: 1));

    final timeString =
        '${messageTime.hour.toString().padLeft(2, '0')}:${messageTime.minute.toString().padLeft(2, '0')}';

    if (messageDate == today) {
      return timeString;
    } else if (messageDate == yesterday) {
      return 'Hôm qua $timeString';
    } else if (messageTime.year == now.year) {
      return '${messageTime.day} th${messageTime.month}';
    } else {
      return '${messageTime.day} th${messageTime.month} ${messageTime.year}';
    }
  }

  Map<String, String>? getLastMessage(int accountId, int currentUserId) {
    final conversationMessages = _chats
        .where((chat) => _isMessageBetweenUsers(chat, currentUserId, accountId))
        .toList();

    if (conversationMessages.isEmpty) return null;

    conversationMessages.sort((a, b) => b.createAt.compareTo(a.createAt));
    final lastMessage = conversationMessages.first;

    final prefix = lastMessage.senderId == currentUserId ? 'Bạn: ' : '';
    final content = '$prefix${lastMessage.content}';
    final timeText = _formatMessageTime(lastMessage.createAt);

    return {'content': content, 'time': timeText};
  }

  void disconnectSocket() {
    socketClient.disconnect();
  }

  void disposeProvider() {
    _msgSub?.cancel();
    _ackSub?.cancel();
    _ackTimer?.cancel();
    socketClient.dispose();
  }
}
