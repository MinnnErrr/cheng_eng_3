import 'package:cheng_eng_3/firebase_options.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_service.g.dart';

@Riverpod(keepAlive: true)
ChatService chatService(Ref ref) {
  return ChatService();
}

class ChatService {
  late final GenerativeModel _model;
  late final ChatSession _chatSession;
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    _model = FirebaseAI.googleAI().generativeModel(
      model: 'gemini-2.5-flash',
    );

    _chatSession = _model.startChat();
    _isInitialized = true;
  }

  Future<GenerateContentResponse> sendMessage(String message) async {
    if (!_isInitialized) {
      await init();
    }
    return _chatSession.sendMessage(Content.text(message));
  }
}
