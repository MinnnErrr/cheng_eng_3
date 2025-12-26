import 'package:cheng_eng_3/core/services/chat_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_notifier.g.dart';

// Simple model for our UI
class ChatMessage {
  final String text;
  final bool isUser;
  final bool isLoading;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.isLoading = false,
  });
}

@riverpod
class ChatNotifier extends _$ChatNotifier {
  ChatService get _chatService => ref.read(chatServiceProvider);

  @override
  List<ChatMessage> build() {
    // Initialize the service when the provider is built
    _chatService.init();

    // Return initial welcome message
    return [
      ChatMessage(
        text: "Hello! How can I help you?",
        isUser: false,
      ),
    ];
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    state = [
      ...state,
      ChatMessage(text: text, isUser: true),
      ChatMessage(
        text: "",
        isUser: false,
        isLoading: true, // ✅ Show spinner immediately
      ),
    ];

    try {
      // 3. Stream the response
      final response = await _chatService.sendMessage(text);

      final responseText = response.text ?? "Couldn't generate a response.";

      // Update the last message (AI) with the accumulating text
      state = [
        ...state.sublist(0, state.length - 1),
        ChatMessage(text: responseText, isUser: false, isLoading: false),
      ];
    } catch (e) {
      print('chat error: $e');
      // Handle Error
      state = [
        ...state.sublist(0, state.length - 1),
        ChatMessage(
          text: "Sorry, something went wrong. Please try again.",
          isUser: false,
          isLoading: false,
        ),
      ];
    }
  }
}
