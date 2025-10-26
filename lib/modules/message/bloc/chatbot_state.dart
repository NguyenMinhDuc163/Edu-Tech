part of 'chatbot_cubit.dart';

@immutable
sealed class ChatbotState {}

final class ChatbotInitial extends ChatbotState {}

final class ChatbotInProgress extends ChatbotState {}

final class ChatbotSuccess extends ChatbotState {
  final String answer;
  final String rawAnswer;

  ChatbotSuccess({required this.answer, required this.rawAnswer});
}

final class ChatbotFailure extends ChatbotState {
  final String message;

  ChatbotFailure({required this.message});
}

final class ChatbotError extends ChatbotState {
  final String message;

  ChatbotError({required this.message});
}
