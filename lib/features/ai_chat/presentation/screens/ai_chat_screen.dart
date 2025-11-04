import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/app_theme.dart';
import 'package:summercamp/core/widgets/custom_ai_chat_bubble.dart';
import 'package:summercamp/features/ai_chat/presentation/state/ai_chat_provider.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage(AIChatProvider provider) {
    if (_controller.text.trim().isEmpty) return;

    final userMsg = _controller.text.trim();
    _controller.clear();

    provider.sendMessage(userMsg);

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AIChatProvider>();

    if (provider.messages.isNotEmpty) {
      _scrollToBottom();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "AI Chat 🤖",
          style: TextStyle(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.bold,
          ),
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
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              itemCount:
                  provider.messages.length + (provider.isLoading ? 1 : 0),
              itemBuilder: (_, idx) {
                if (idx == provider.messages.length && provider.isLoading) {
                  return const AIChatBubble(text: "...", isMe: false);
                }

                final msg = provider.messages[idx];
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
                    style: const TextStyle(
                      fontFamily: "Quicksand",
                      fontSize: 15,
                    ),
                    onSubmitted: (value) => _sendMessage(provider),
                    decoration: InputDecoration(
                      hintText: "Nhập tin nhắn...",
                      hintStyle: const TextStyle(
                        fontFamily: "Quicksand",
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
                        borderSide: const BorderSide(
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
                    onPressed: () => _sendMessage(provider),
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
