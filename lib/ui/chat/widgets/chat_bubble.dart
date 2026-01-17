import 'package:cheng_eng_3/ui/chat/notifiers/chat_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_widget/markdown_widget.dart';

class ChatBubble extends ConsumerWidget {
  const ChatBubble({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isUser = message.isUser;
    final backgroundColor = isUser
        ? theme
              .colorScheme
              .primary // Yellow
        : theme.colorScheme.surfaceContainerHigh;
    final textColor = Colors.black;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: isUser
            ? SelectableText(
                message.text,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: textColor,
                  height: 1.4,
                ),
              )
            : message.isLoading
            ? _buildLoadingIndicator(theme)
            : MarkdownBlock(
                data: message.text,
                config: MarkdownConfig.defaultConfig.copy(
                  configs: [
                    PConfig(
                      textStyle:
                          theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.black87, 
                            height: 1.5,
                          ) ??
                          const TextStyle(color: Colors.black87),
                    ),
                    PreConfig(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      textStyle: const TextStyle(
                        color: Colors.black87,
                        fontFamily: 'monospace',
                      ),
                    ),
                    ListConfig(
                      marker: (isOrdered, depth, index) {
                        return Container(
                          margin: const EdgeInsets.only(right: 8, top: 6),
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Colors.black87,
                            shape: BoxShape.circle,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildLoadingIndicator(ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 14,
          height: 14,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.black54, 
          ),
        ),
        const SizedBox(width: 10),
        Text(
          "Thinking...",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.black54,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
