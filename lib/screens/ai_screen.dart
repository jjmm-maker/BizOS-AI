
import 'package:flutter/material.dart';

class AIScreen extends StatefulWidget {
  const AIScreen({super.key});

  @override
  State<AIScreen> createState() => _AIScreenState();
}

class _AIScreenState extends State<AIScreen> {
  final TextEditingController _controller = TextEditingController();

  final List<ChatMessage> _messages = [
    ChatMessage(
      text:
          'Hello! I’m your BizOS AI business assistant. Ask me about your sales, customers, products, or business operations.',
      isUser: false,
    ),
  ];

  void _sendMessage() {
    final text = _controller.text.trim();

    if (text.isEmpty) {
      return;
    }

    setState(() {
      _messages.add(
        ChatMessage(
          text: text,
          isUser: true,
        ),
      );

      _messages.add(
        ChatMessage(
          text: _generateResponse(text),
          isUser: false,
        ),
      );
    });

    _controller.clear();
  }

  String _generateResponse(String message) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('sales')) {
      return 'I can help you analyze your sales performance. Once your business data is connected, I’ll be able to identify trends, top products, and revenue changes.';
    }

    if (lowerMessage.contains('customer')) {
      return 'I can help you understand your customers, including customer activity, repeat purchases, and customer growth.';
    }

    if (lowerMessage.contains('product')) {
      return 'I can help you manage products, monitor stock, identify low-stock items, and understand which products perform best.';
    }

    if (lowerMessage.contains('hello') ||
        lowerMessage.contains('hi')) {
      return 'Hello! What would you like to work on today?';
    }

    return 'I understand. I’ll be able to give you a more intelligent answer once the BizOS AI business engine is connected to your real business data.';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0D),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0B0D),
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFD71920),
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BizOS AI',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'Business Assistant',
                  style: TextStyle(
                    color: Color(0xFFA7A7AD),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _MessageBubble(
                  message: _messages[index],
                );
              },
            ),
          ),

          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
        decoration: const BoxDecoration(
          color: Color(0xFF111114),
          border: Border(
            top: BorderSide(
              color: Color(0xFF29292F),
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
                decoration: InputDecoration(
                  hintText: 'Ask BizOS AI...',
                  filled: true,
                  fillColor: const Color(0xFF1A1A1F),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFD71920),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.arrow_upward,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({
    required this.text,
    required this.isUser,
  });
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const _MessageBubble({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 330,
        ),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 13,
        ),
        decoration: BoxDecoration(
          color: message.isUser
              ? const Color(0xFFD71920)
              : const Color(0xFF19191D),
          borderRadius: BorderRadius.circular(18),
          border: message.isUser
              ? null
              : Border.all(
                  color: const Color(0xFF29292F),
                ),
        ),
        child: Text(
          message.text,
          style: const TextStyle(
            height: 1.4,
          ),
        ),
      ),
    );
  }
}