import 'package:ed_tech/modules/purchased_courses/model/purchased_course_response.dart';

sealed class PurchasedCourseState {}

class PurchasedCourseInitial extends PurchasedCourseState {}

class PurchasedCourseProgress extends PurchasedCourseState {}

class PurchasedCourseSuccess extends PurchasedCourseState {
  final List<PurchasedCourse> courses;

  PurchasedCourseSuccess({required this.courses});
}

class PurchasedCourseError extends PurchasedCourseState {
  final String message;

  PurchasedCourseError({this.message = 'Đã xảy ra lỗi'});
}
