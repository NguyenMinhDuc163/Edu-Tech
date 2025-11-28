part of 'filter_course_cubit.dart';

abstract class FilterCourseState {}

class FilterCourseInitial extends FilterCourseState {}

class FilterCourseProgress extends FilterCourseState {}

class FilterCourseSuccess extends FilterCourseState {
  final List<SearchCourseResult> results;

  FilterCourseSuccess({required this.results});
}

class FilterCourseError extends FilterCourseState {
  final String message;

  FilterCourseError({required this.message});
}
