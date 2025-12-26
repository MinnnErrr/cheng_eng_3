import 'package:cheng_eng_3/core/services/chat_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'chat_notifier.g.dart';

// Simple model for our UI
class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final bool isLoading;

  ChatMessage({
    required this.id,
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
        id: const Uuid().v4(),
        text:
            "Hello! I am your AI assistant. How can I help you with your vehicle today?",
        isUser: false,
      ),
    ];
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMsgId = const Uuid().v4();
    final aiMsgId = const Uuid().v4();

    // 1. Add User Message immediately
    final userMsg = ChatMessage(id: userMsgId, text: text, isUser: true);
    state = [userMsg, ...state,];

    // 2. Add a temporary "Loading..." AI message
    final loadingMsg = ChatMessage(
      id: aiMsgId,
      text: "",
      isUser: false,
      isLoading: true,
    );
    state = [loadingMsg, ...state];

    try {
      // 3. Stream the response
      final stream = _chatService.sendMessage(text);

      String fullResponse = "";

      await for (final chunk in stream) {
        final textChunk = chunk.text ?? "";
        fullResponse += textChunk;

        // Update the last message (AI) with the accumulating text
        state = [
          ChatMessage(
            id: aiMsgId,
            text: fullResponse,
            isUser: false,
            isLoading: false, // Show text now
          ),
          ...state,
        ];
      }
    } catch (e) {
      // Handle Error
      state = [
        ChatMessage(
          id: aiMsgId,
          text: "Sorry, I encountered an error. Please try again.",
          isUser: false,
        ),
        ...state,
        
      ];
    }
  }
}
