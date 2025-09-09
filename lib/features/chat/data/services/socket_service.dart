import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:summercamp/core/config/constants.dart';
import 'package:summercamp/features/chat/data/models/chat_model.dart';

class SocketService {
  io.Socket? _socket;
  final StreamController<ChatModel> _messageController =
      StreamController.broadcast();
  final StreamController<ChatModel> _ackController =
      StreamController.broadcast();

  Stream<ChatModel> get onMessage => _messageController.stream;
  Stream<ChatModel> get onAck => _ackController.stream;

  void connect(String token) {
    disconnect();
    _socket = io.io(AppConstants.socketUrl, <String, dynamic>{
      'transports': ['websocket', 'polling'],
      'autoConnect': true,
      'auth': {'token': token},
      'reconnection': true,
    });

    _socket?.on('connect', (_) {
      // connected
    });

    _socket?.on('message', (data) {
      try {
        final msg = ChatModel.fromJson(Map<String, dynamic>.from(data));
        _messageController.add(msg);
      } catch (e) {
        // ignore parse errors
      }
    });

    _socket?.on('messageAck', (data) {
      final ack = ChatModel.fromJson(Map<String, dynamic>.from(data));
      _ackController.add(ack);
    });

    _socket?.on('disconnect', (_) {
      // handle disconnect
    });

    _socket?.on('connect_error', (err) {
      // handle connect error
    });
  }

  void sendMessage(int receiverId, String content) {
    if (_socket != null && _socket!.connected) {
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
