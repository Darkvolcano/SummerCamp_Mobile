import 'package:flutter/material.dart';
import 'package:summercamp/core/config/app_theme.dart';

class InputMessage extends StatefulWidget {
  final Function(String) onSend;
  final bool isStaff;
  const InputMessage({super.key, required this.onSend, this.isStaff = false});

  @override
  State<InputMessage> createState() => _InputMessageState();
}

class _InputMessageState extends State<InputMessage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final primaryColor = widget.isStaff
        ? const Color(0xFF1565C0)
        : AppTheme.summerPrimary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            style: const TextStyle(fontFamily: "Quicksand"),
            cursorColor: primaryColor,
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: 5,
            textInputAction: TextInputAction.newline,
            decoration: InputDecoration(
              hintText: 'Nhập tin nhắn...',
              hintStyle: const TextStyle(fontFamily: "Quicksand"),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: primaryColor, width: 1.5),
              ),
            ),
            onSubmitted: (_) => _send(),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 48,
          height: 48,
          child: ElevatedButton(
            onPressed: _send,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              padding: EdgeInsets.zero,
              shape: const CircleBorder(),
              alignment: Alignment.center,
            ),
            child: const Icon(Icons.send, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
  }
}
