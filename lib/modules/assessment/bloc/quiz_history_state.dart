part of 'quiz_history_cubit.dart';

@immutable
sealed class QuizHistoryState {}

final class QuizHistoryInitial extends QuizHistoryState {}

final class QuizHistoryLoading extends QuizHistoryState {}

final class QuizHistorySuccess extends QuizHistoryState {
  final QuizHistoryModel data;

  QuizHistorySuccess({required this.data});
}

final class QuizHistoryError extends QuizHistoryState {
  final String message;

  QuizHistoryError({required this.message});
}
