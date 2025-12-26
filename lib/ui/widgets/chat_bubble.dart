import 'package:cheng_eng_3/core/controllers/chat/chat_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_widget/markdown_widget.dart';

class ChatBubble extends ConsumerWidget {
  const ChatBubble({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUser = message.isUser;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        decoration: BoxDecoration(
          color: isUser ? Colors.amber : Colors.grey[200],
          borderRadius: BorderRadius.only(
            bottomLeft: const Radius.circular(16),
            bottomRight: const Radius.circular(16),
            topLeft: Radius.circular(isUser ? 16 : 0),
            topRight: Radius.circular(isUser ? 0 : 16),
          ),
        ),
        child: isUser
            ? Text(
                message.text,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              )
            : message.isLoading
            ? _buildLoadingIndicator()
            : MarkdownBlock(
                data: message.text,
                config: MarkdownConfig.defaultConfig.copy(
                  configs: [
                    // Optional: Customize Link styles or Code Block styles here
                    const PConfig(textStyle: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.black54,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          "Thinking...",
          style: TextStyle(
            color: Colors.black54,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
