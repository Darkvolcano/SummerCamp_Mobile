import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/features/auth/presentation/state/auth_provider.dart';
import 'package:summercamp/features/chat/presentation/state/chat_provider.dart';
import 'package:summercamp/features/chat/presentation/widgets/chat_bubble.dart';
import 'package:summercamp/features/chat/presentation/widgets/input_message.dart';

class ChatDetailScreen extends StatelessWidget {
  const ChatDetailScreen({super.key});

  String formatTimestamp(DateTime dt) {
    final now = DateTime.now();

    // hôm nay
    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      return DateFormat('HH:mm').format(dt);
    }

    // trong cùng 1 tuần (tính từ thứ 2 -> CN)
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(
      const Duration(days: 6, hours: 23, minutes: 59),
    );

    if (dt.isAfter(startOfWeek) && dt.isBefore(endOfWeek)) {
      // vd: Thứ 2, Thứ 3... (ở VN Thứ 2 = weekday 1)
      final weekdays = {
        1: 'T2',
        2: 'T3',
        3: 'T4',
        4: 'T5',
        5: 'T6',
        6: 'T7',
        7: 'CN',
      };
      return '${weekdays[dt.weekday]} lúc ${DateFormat('HH:mm').format(dt)}';
    }

    // tuần trước trở về sau
    return DateFormat('dd/MM HH:mm').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final chatProv = Provider.of<ChatProvider>(context);
    final authProv = Provider.of<AuthProvider>(context);
    final selected = chatProv.selectedUser;

    if (selected == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final displayName = "${selected.lastName} ${selected.firstName}";

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(backgroundColor: const Color(0xFFA05A2C)),
            const SizedBox(width: 12),
            Text(displayName),
          ],
        ),
        backgroundColor: const Color(0xFFA05A2C),
      ),
      body: Column(
        children: [
          Expanded(
            child: chatProv.chats.isEmpty
                ? const Center(
                    child: Text(
                      'Chưa có tin nhắn nào.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: chatProv.chats.length,
                    itemBuilder: (_, idx) {
                      final c = chatProv.chats[idx];
                      final isMe = c.senderId == authProv.user?.id;

                      // quyết định có chèn timestamp separator hay không
                      bool showTimeSeparator = false;
                      String? timeText;

                      if (idx == 0) {
                        showTimeSeparator = true;
                        timeText = formatTimestamp(c.createAt);
                      } else {
                        final prev = chatProv.chats[idx - 1];
                        final diff = c.createAt
                            .difference(prev.createAt)
                            .inMinutes;
                        if (diff >= 10) {
                          showTimeSeparator = true;
                          timeText = formatTimestamp(c.createAt);
                        }
                      }
                      return Column(
                        children: [
                          if (showTimeSeparator && timeText != null)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    timeText,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ChatBubble(
                            text: c.content,
                            isMe: isMe,
                            time: c.createAt,
                          ),
                        ],
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: InputMessage(
                    onSend: (text) => chatProv.sendMessage(selected.id, text),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
