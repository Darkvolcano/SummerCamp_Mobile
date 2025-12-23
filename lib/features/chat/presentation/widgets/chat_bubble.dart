import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatefulWidget {
  final String text;
  final bool isMe;
  final bool isStaff;
  final DateTime time;

  const ChatBubble({
    super.key,
    required this.text,
    required this.isMe,
    this.isStaff = false,
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

    const staffPrimaryColor = Color(0xFF1565C0);
    const staffLightBgColor = Color(0xFFE3F2FD);
    const staffTextColorDark = Color(0xFF0D47A1);

    const userPrimaryColor = Color(0xFFA05A2C);
    const userLightBgColor = Color(0xFFF5EAD9);
    const userTextColorDark = Color(0xFF5D4037);

    Color backgroundColor;
    Color textColor;

    if (widget.isMe) {
      backgroundColor = widget.isStaff ? staffPrimaryColor : userPrimaryColor;
      textColor = Colors.white;
    } else {
      backgroundColor = widget.isStaff ? staffLightBgColor : userLightBgColor;
      textColor = widget.isStaff ? staffTextColorDark : userTextColorDark;
    }

    final displayTime = widget.time.add(const Duration(hours: 7));

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
                    color: backgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(12),
                      topRight: const Radius.circular(12),
                      bottomLeft: widget.isMe
                          ? const Radius.circular(12)
                          : const Radius.circular(4),
                      bottomRight: widget.isMe
                          ? const Radius.circular(4)
                          : const Radius.circular(12),
                    ),
                    border: (!widget.isMe && widget.isStaff)
                        ? Border.all(color: Colors.blue.shade200, width: 1)
                        : null,
                  ),
                  child: Text(
                    widget.text,
                    style: TextStyle(
                      fontFamily: "Quicksand",
                      color: textColor,
                      fontSize: 15,
                      fontWeight: widget.isStaff && !widget.isMe
                          ? FontWeight.w500
                          : FontWeight.normal,
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
                    formatTimestamp(displayTime),
                    style: const TextStyle(
                      fontFamily: "Quicksand",
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
