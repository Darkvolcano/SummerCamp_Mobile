import 'package:flutter/material.dart';
import 'package:summercamp/core/config/app_theme.dart';
import 'package:summercamp/core/widgets/custom_ai_chat_bubble.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  final List<String> aiReplies = [
    "Xin chào 👋, tôi là trợ lý AI của bạn!",
    "Bạn có muốn xem các trại hè nổi bật không?",
    "Hãy thử đăng ký một trại hè nhé 🚀",
    "Tôi có thể giúp gì cho bạn hôm nay?",
  ];

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    final userMsg = _controller.text.trim();
    setState(() {
      _messages.add({"text": userMsg, "isMe": true});
    });
    _controller.clear();

    Future.delayed(const Duration(seconds: 1), () {
      final aiMsg = (aiReplies..shuffle()).first;
      setState(() {
        _messages.add({"text": aiMsg, "isMe": false});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "AI Chat 🤖",
          style: TextStyle(fontFamily: "Fredoka", fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.summerPrimary,
        foregroundColor: Colors.white,
        elevation: 3,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (_, idx) {
                final msg = _messages[idx];
                return AIChatBubble(text: msg["text"], isMe: msg["isMe"]);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(fontFamily: "Nunito", fontSize: 15),
                    decoration: InputDecoration(
                      hintText: "Nhập tin nhắn...",
                      hintStyle: const TextStyle(
                        fontFamily: "Nunito",
                        color: Colors.black54,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(
                          color: AppTheme.summerPrimary,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(
                          color: AppTheme.summerPrimary,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: AppTheme.summerPrimary,
                  radius: 24,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
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
