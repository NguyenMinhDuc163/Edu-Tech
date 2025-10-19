part of 'course_cubit.dart';

@immutable
sealed class CourseState {}


class CourseInitial extends CourseState {}

class CourseProgress extends CourseState {}

class CourseSuccess extends CourseState {
  final List<DataCourse> courses;

  CourseSuccess({required this.courses});
}

class CourseFailure extends CourseState {
  final String message;

  CourseFailure({this.message = 'Lấy danh sách khóa học thất bại'});
}

class CourseError extends CourseState {
  final String message;

  CourseError({this.message = 'Đã xảy ra lỗi'});
}


class CourseDetailInitial extends CourseState {}

class CourseDetailProgress extends CourseState {}

class CourseDetailSuccess extends CourseState {
  final DataData courseDetail;

  CourseDetailSuccess({required this.courseDetail});
}

class CourseDetailFailure extends CourseState {
  final String message;

  CourseDetailFailure({this.message = 'Lấy chi tiết khóa học thất bại'});
}

class CourseDetailError extends CourseState {
  final String message;

  CourseDetailError({this.message = 'Đã xảy ra lỗi'});
}
