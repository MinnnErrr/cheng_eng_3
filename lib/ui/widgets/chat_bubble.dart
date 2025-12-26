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
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        decoration: BoxDecoration(
          color: isUser ? Colors.amber : Colors.grey[200],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 16),
          ),
        ),
        child: isUser
            ? Text(
                message.text,
                style: const TextStyle(color: Colors.white),
              )
            : message.isLoading && message.text.isEmpty
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
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
}
