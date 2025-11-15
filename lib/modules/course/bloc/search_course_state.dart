part of 'search_course_cubit.dart';

sealed class SearchCourseState {}

class SearchCourseInitial extends SearchCourseState {
  final List historyList;

  SearchCourseInitial({this.historyList = const []});
}

class SearchCourseProgress extends SearchCourseState {}

class SearchCourseSuccess extends SearchCourseState {
  final List results;

  SearchCourseSuccess({required this.results});
}

class SearchCourseError extends SearchCourseState {
  final String message;

  SearchCourseError({required this.message});
}

class SearchHistoryLoaded extends SearchCourseState {
  final List historyList;

  SearchHistoryLoaded({required this.historyList});
}
