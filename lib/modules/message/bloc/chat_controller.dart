import 'package:disposable_provider/disposable_provider.dart';
import 'package:ed_tech/core/data_types.dart';

class ChatController extends Disposable {
  final BoolVs isTyping = BoolVs(false);
  final StringVs messageText = StringVs('');
  final BoolVs isBotResponding = BoolVs(false);
  final BoolVs isHistoryVisible = BoolVs(false);

  void toggleTyping() {
    isTyping.value = !isTyping.value;
  }

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

  @override
  void dispose() {
    isTyping.dispose();
    messageText.dispose();
    isBotResponding.dispose();
    isHistoryVisible.dispose();
  }
}
