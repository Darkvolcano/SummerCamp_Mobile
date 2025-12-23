import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';

import 'package:signalr_netcore/signalr_client.dart';

class SignalRService {
  HubConnection? _hubConnection;

  String get _hubUrl {
    final apiUrl = dotenv.env['BE_CHAT_API'] ?? '';
    final baseUrl = apiUrl.replaceAll(RegExp(r'api$'), '');
    return "$baseUrl/hubs/chat";
  }

  Function(Map<String, dynamic>)? onMessageReceived;

  bool get isConnected => _hubConnection?.state == HubConnectionState.Connected;

  String? _currentRoomId;

  Future<void> initSignalR(String token) async {
    if (isConnected) return;

    print('[SignalR] Initializing connection to: $_hubUrl');

    _hubConnection = HubConnectionBuilder()
        .withUrl(
          _hubUrl,
          options: HttpConnectionOptions(accessTokenFactory: () async => token),
        )
        .withAutomaticReconnect(retryDelays: [0, 2000, 5000, 10000])
        .build();

    _hubConnection!.on("ReceiveMessage", _handleIncomingMessage);

    _hubConnection!.onclose(({error}) {
      print('[SignalR] Connection closed. Error: $error');
    });

    _hubConnection!.onreconnecting(({error}) {
      print('[SignalR] Reconnecting... Error: $error');
    });

    _hubConnection!.onreconnected(({connectionId}) {
      print('[SignalR] Reconnected successfully. ID: $connectionId');
      if (_currentRoomId != null) {
        joinRoom(_currentRoomId!);
      }
    });

    try {
      await _hubConnection!.start();
      print(
        '[SignalR] Connection started successfully, state: ${_hubConnection!.state}',
      );
    } catch (e) {
      print('[SignalR] Connection error: $e');
    }
  }

  void _handleIncomingMessage(List<Object?>? arguments) {
    if (arguments != null && arguments.isNotEmpty) {
      final messageData = arguments[0] as Map<String, dynamic>;
      print('[SignalR] Received message: $messageData');

      if (onMessageReceived != null) {
        onMessageReceived!(messageData);
      }
    }
  }

  Future<void> joinRoom(String roomId) async {
    if (!isConnected) {
      print('[SignalR] Cannot join room: No connection');
      return;
    }

    try {
      if (_currentRoomId != null && _currentRoomId != roomId) {
        await leaveRoom(_currentRoomId!);
      }

      print('[SignalR] Joining room: $roomId');
      await _hubConnection!.invoke("JoinRoom", args: [roomId]);
      _currentRoomId = roomId;
      print('[SignalR] Successfully joined room: $roomId');
    } catch (err) {
      print('[SignalR] Failed to join room $roomId: $err');
    }
  }

  Future<void> leaveRoom(String roomId) async {
    if (!isConnected) return;

    try {
      print('[SignalR] Leaving room: $roomId');
      await _hubConnection!.invoke("LeaveRoom", args: [roomId]);
      if (_currentRoomId == roomId) {
        _currentRoomId = null;
      }
    } catch (err) {
      print('[SignalR] Failed to leave room $roomId: $err');
    }
  }

  Future<void> stop() async {
    if (_hubConnection != null) {
      await _hubConnection!.stop();
      _hubConnection = null;
      _currentRoomId = null;
      print('[SignalR] Connection stopped');
    }
  }
}
