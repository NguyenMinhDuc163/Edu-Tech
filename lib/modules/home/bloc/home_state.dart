import 'package:ed_tech/modules/home/model/course_response.dart';
import 'package:ed_tech/modules/home/model/course_stats_response.dart';
import 'package:ed_tech/modules/home/model/learning_progress_response.dart';

sealed class HomeState {}

class HomeInitial extends HomeState {}

class HomeInProgress extends HomeState {}

class HomeSuccess extends HomeState {}

class HomeFailure extends HomeState {
  final String message;

  HomeFailure({this.message = 'Lấy dữ liệu thất bại'});
}

class HomeError extends HomeState {
  final String message;

  HomeError({this.message = 'Đã xảy ra lỗi'});
}

class CourseInitial extends HomeState {}

class CourseProgress extends HomeState {}

class CourseSuccess extends HomeState {
  final List<DataCourse> courses;

  CourseSuccess({required this.courses});
}

class CourseFailure extends HomeState {
  final String message;

  CourseFailure({this.message = 'Lấy dữ liệu thất bại'});
}

class CourseError extends HomeState {
  final String message;

  CourseError({this.message = 'Đã xảy ra lỗi'});
}

class StatsInitial extends HomeState {}

class StatsProgress extends HomeState {}

class StatsSuccess extends HomeState {
  final CourseStatsData stats;

  StatsSuccess({required this.stats});
}

class StatsError extends HomeState {
  final String message;

  StatsError({this.message = 'Đã xảy ra lỗi'});
}

class ProgressInitial extends HomeState {}

class ProgressLoading extends HomeState {}

class ProgressSuccess extends HomeState {
  final LearningProgressData progress;

  ProgressSuccess({required this.progress});
}

class ProgressError extends HomeState {
  final String message;

  ProgressError({this.message = 'Đã xảy ra lỗi'});
}
