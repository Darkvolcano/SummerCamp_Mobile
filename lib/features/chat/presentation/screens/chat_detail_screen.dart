import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/app_theme.dart';
import 'package:summercamp/features/auth/presentation/state/auth_provider.dart';
import 'package:summercamp/features/chat/presentation/state/chat_provider.dart';
import 'package:summercamp/features/chat/presentation/widgets/chat_bubble.dart';
import 'package:summercamp/features/chat/presentation/widgets/input_message.dart';

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({super.key});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  String formatTimestamp(DateTime dt) {
    final displayTime = dt.add(const Duration(hours: 7));
    final now = DateTime.now();

    if (displayTime.year == now.year &&
        displayTime.month == now.month &&
        displayTime.day == now.day) {
      return DateFormat('HH:mm').format(displayTime);
    }

    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(
      const Duration(days: 6, hours: 23, minutes: 59),
    );

    if (displayTime.isAfter(startOfWeek) && displayTime.isBefore(endOfWeek)) {
      final weekdays = {
        1: 'T2',
        2: 'T3',
        3: 'T4',
        4: 'T5',
        5: 'T6',
        6: 'T7',
        7: 'CN',
      };
      return '${weekdays[displayTime.weekday]} lúc ${DateFormat('HH:mm').format(displayTime)}';
    }

    return DateFormat('dd/MM HH:mm').format(displayTime);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ChatProvider, AuthProvider>(
      builder: (context, chatProv, authProv, child) {
        final selectedRoom = chatProv.selectedRoom;
        final messages = chatProv.currentMessages;

        SchedulerBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });

        return PopScope(
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) {
              chatProv.clearSelection();
            }
          },
          child: Scaffold(
            backgroundColor: const Color(0xFFF5F7F8),
            appBar: AppBar(
              backgroundColor: AppTheme.summerPrimary,
              iconTheme: const IconThemeData(color: Colors.white),
              title: selectedRoom == null
                  ? const SizedBox.shrink()
                  : Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white,
                          backgroundImage: selectedRoom.avatarUrl != null
                              ? NetworkImage(selectedRoom.avatarUrl!)
                              : null,
                          child: selectedRoom.avatarUrl == null
                              ? Text(
                                  selectedRoom.name.isNotEmpty
                                      ? selectedRoom.name[0].toUpperCase()
                                      : '?',
                                  style: const TextStyle(
                                    color: AppTheme.summerPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Quicksand",
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            selectedRoom.name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: "Quicksand",
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
            body: selectedRoom == null
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.summerPrimary,
                    ),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: chatProv.isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: AppTheme.summerPrimary,
                                ),
                              )
                            : messages.isEmpty
                            ? const Center(
                                child: Text(
                                  'Chưa có tin nhắn nào.\nHãy bắt đầu trò chuyện!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: "Quicksand",
                                    fontSize: 16,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                controller: _scrollController,
                                padding: const EdgeInsets.all(16),
                                itemCount: messages.length,
                                itemBuilder: (_, idx) {
                                  final msg = messages[idx];
                                  final isMe =
                                      msg.senderId == authProv.user?.userId;

                                  bool showTimeSeparator = false;
                                  String? timeText;

                                  if (idx == 0) {
                                    showTimeSeparator = true;
                                    timeText = formatTimestamp(msg.sentAt);
                                  } else {
                                    final prev = messages[idx - 1];
                                    final diff = msg.sentAt
                                        .difference(prev.sentAt)
                                        .inMinutes;
                                    if (diff >= 10) {
                                      showTimeSeparator = true;
                                      timeText = formatTimestamp(msg.sentAt);
                                    }
                                  }

                                  return Column(
                                    children: [
                                      if (showTimeSeparator && timeText != null)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12.0,
                                          ),
                                          child: Center(
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade200,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                timeText,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                  fontFamily: "Quicksand",
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ChatBubble(
                                        text: msg.content,
                                        isMe: isMe,
                                        isStaff: false,
                                        time: msg.sentAt,
                                      ),
                                    ],
                                  );
                                },
                              ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              offset: const Offset(0, -2),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: InputMessage(
                                onSend: (text) {
                                  chatProv.sendMessage(text);
                                  _scrollToBottom();
                                },
                                isStaff: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
