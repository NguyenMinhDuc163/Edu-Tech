import 'package:disposable_provider/disposable_provider.dart';
import 'package:ed_tech/core/data_types.dart';

class ChatController extends Disposable {
  final StringVs messageText = StringVs('');
  final BoolVs isBotResponding = BoolVs(false);
  final BoolVs isHistoryVisible = BoolVs(false);
  final ListVs<ChatMessage> messages = ListVs<ChatMessage>([]);

  void updateMessageText(String text) {
    messageText.value = text;
  }

  void setBotResponding(bool responding) {
    isBotResponding.value = responding;
  }

  void toggleHistory() {
    isHistoryVisible.value = !isHistoryVisible.value;
  }

  void clearMessage() {
    messageText.value = '';
  }

  void addMessage(ChatMessage message) {
    messages.add(message);
  }

  void clearMessages() {
    messages.clear();
  }

  @override
  void dispose() {
    messageText.dispose();
    isBotResponding.dispose();
    isHistoryVisible.dispose();
    messages.dispose();
  }
}

class ChatMessage {
  final String content;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.content,
    required this.isUser,
    required this.timestamp,
  });
}
