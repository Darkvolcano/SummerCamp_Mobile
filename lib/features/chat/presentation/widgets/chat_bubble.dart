import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatefulWidget {
  final String text;
  final bool isMe;
  final DateTime time;

  const ChatBubble({
    super.key,
    required this.text,
    required this.isMe,
    required this.time,
  });

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  bool _showTime = false;

  void _toggleTime() {
    setState(() => _showTime = !_showTime);
  }

  String formatTimestamp(DateTime dt) {
    final now = DateTime.now();

    // for today
    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      return DateFormat('HH:mm').format(dt);
    }

    // in this week (from 2 -> CN)
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(
      const Duration(days: 6, hours: 23, minutes: 59),
    );

    if (dt.isAfter(startOfWeek) && dt.isBefore(endOfWeek)) {
      const weekdays = {
        1: 'T2',
        2: 'T3',
        3: 'T4',
        4: 'T5',
        5: 'T6',
        6: 'T7',
        7: 'CN',
      };
      return '${weekdays[dt.weekday]} ${DateFormat('HH:mm').format(dt)}';
    }

    // last week before
    return DateFormat('dd/MM HH:mm').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width * 0.7;

    return GestureDetector(
      onTap: _toggleTime,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // bubble align follow left/right
            Align(
              alignment: widget.isMe
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: widget.isMe
                        ? const Color(0xFFA05A2C)
                        : const Color(0xFFF5EAD9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.text,
                    style: TextStyle(
                      color: widget.isMe
                          ? Colors.white
                          : const Color(0xFF5D4037),
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),

            // dropdown time when click, align with bubble
            if (_showTime)
              Align(
                alignment: widget.isMe
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4, left: 8, right: 8),
                  child: Text(
                    formatTimestamp(widget.time),
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
