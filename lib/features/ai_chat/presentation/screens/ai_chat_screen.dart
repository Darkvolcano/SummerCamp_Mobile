import 'package:flutter/material.dart';
import 'package:summercamp/core/widgets/custom_ai_chat_bubble.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = []; // {text, isMe}

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

    // giả lập AI trả lời sau 1s
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
        title: const Text("AI Chat 🤖"),
        backgroundColor: const Color(0xFFA05A2C),
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
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Nhập tin nhắn...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFFA05A2C)),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
