import 'package:cheng_eng_3/data/services/chat_service.dart';
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
    _chatService.init();

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
        isLoading: true, 
      ),
    ];

    try {
      final response = await _chatService.sendMessage(text);

      final responseText = response.text ?? "Couldn't generate a response.";

      state = [
        ...state.sublist(0, state.length - 1),
        ChatMessage(text: responseText, isUser: false, isLoading: false),
      ];
    } catch (e) {
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
