import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:summercamp/core/config/constants.dart';
import 'package:summercamp/features/chat/data/models/chat_model.dart';

class SocketClient {
  static final SocketClient _instance = SocketClient._internal();
  factory SocketClient() => _instance;
  SocketClient._internal();

  io.Socket? _socket;
  String? _token;

  final _messageController = StreamController<ChatModel>.broadcast();
  final _ackController = StreamController<ChatModel>.broadcast();

  Stream<ChatModel> get onMessage => _messageController.stream;
  Stream<ChatModel> get onAck => _ackController.stream;
  bool get connected => _socket?.connected ?? false;

  // set token after login
  void setToken(String token) {
    _token = token;
  }

  // Connect socket with token
  void connect() {
    disconnect();

    if (_token == null) {
      throw Exception("Token null. Gọi setToken() sau khi login");
    }

    _socket = io.io(AppConstants.socketUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'auth': {'token': _token},
      'reconnection': true,
    });

    _socket?.on('connect', (_) => print("Socket connected"));
    _socket?.on('disconnect', (_) => print("Socket disconnected"));
    _socket?.on('connect_error', (err) => print("Socket error: $err"));

    _socket?.on('message', (data) {
      try {
        final msg = ChatModel.fromJson(Map<String, dynamic>.from(data));
        _messageController.add(msg);
      } catch (_) {}
    });

    _socket?.on('messageAck', (data) {
      try {
        final ack = ChatModel.fromJson(Map<String, dynamic>.from(data));
        _ackController.add(ack);
      } catch (_) {}
    });
  }

  void sendMessage(int receiverId, String content) {
    if (connected) {
      _socket!.emit('sendMessage', {
        'receiverId': receiverId,
        'content': content,
      });
    } else {
      throw Exception('Socket not connected');
    }
  }

  void disconnect() {
    _socket?.disconnect();
    _socket = null;
  }

  void dispose() {
    _messageController.close();
    _ackController.close();
    disconnect();
  }
}
