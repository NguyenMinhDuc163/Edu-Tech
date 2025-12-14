part of 'chat_history_cubit.dart';

@immutable
sealed class ChatHistoryState {}

final class ChatHistoryInitial extends ChatHistoryState {}

final class ChatHistoryLoading extends ChatHistoryState {}

final class ChatHistorySuccess extends ChatHistoryState {
  final List<ChatSession> sessions;
  final int total;
  final int currentPage;
  final int limit;
  final bool hasMore;

  ChatHistorySuccess({
    required this.sessions,
    required this.total,
    required this.currentPage,
    required this.limit,
  }) : hasMore = sessions.length < total;
}

final class ChatHistoryFailure extends ChatHistoryState {
  final String message;

  ChatHistoryFailure({required this.message});
}

final class ChatHistoryError extends ChatHistoryState {
  final String message;

  ChatHistoryError({required this.message});
}
