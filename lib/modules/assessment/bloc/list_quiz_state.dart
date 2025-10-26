part of 'list_quiz_cubit.dart';

@immutable
sealed class ListQuizState {}

final class ListQuizInitial extends ListQuizState {}

final class ListQuizInProgress extends ListQuizState {}

final class ListQuizSuccess extends ListQuizState {
  final ListQuizModel data;

  ListQuizSuccess({required this.data});
}

final class ListQuizFailure extends ListQuizState {
  final String message;

  ListQuizFailure({required this.message});
}

final class ListQuizError extends ListQuizState {
  final String message;

  ListQuizError({required this.message});
}
