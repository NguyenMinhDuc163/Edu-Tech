part of 'chatbot_cubit.dart';

@immutable
sealed class ChatbotState {}

final class ChatbotInitial extends ChatbotState {}

final class ChatbotInProgress extends ChatbotState {}

final class ChatbotSuccess extends ChatbotState {
  final String responseHtml;
  final String responseRaw;
  final String sessionId;

  ChatbotSuccess({
    required this.responseHtml,
    required this.responseRaw,
    required this.sessionId,
  });
}

final class ChatbotFailure extends ChatbotState {
  final String message;

  ChatbotFailure({required this.message});
}

final class ChatbotError extends ChatbotState {
  final String message;

  ChatbotError({required this.message});
}
