part of 'quiz_taking_cubit.dart';

@immutable
sealed class QuizTakingState {}

final class QuizTakingInitial extends QuizTakingState {}

final class QuizTakingInProgress extends QuizTakingState {}

final class QuizTakingSuccess extends QuizTakingState {
  final DetailQuizModel data;

  QuizTakingSuccess({required this.data});
}

final class QuizTakingError extends QuizTakingState {
  final String message;

  QuizTakingError({required this.message});
}

// Submit quiz states
final class QuizSubmitInProgress extends QuizTakingState {}

final class QuizSubmitSuccess extends QuizTakingState {
  final SubmitQuizModel data;

  QuizSubmitSuccess({required this.data});
}

final class QuizSubmitError extends QuizTakingState {
  final String message;

  QuizSubmitError({required this.message});
}
