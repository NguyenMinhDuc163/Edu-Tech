import 'package:ed_tech/core/error_handling/app_error_state.dart';
import 'package:ed_tech/init.dart';
import 'package:ed_tech/modules/course/model/detail_course.dart';
import 'package:ed_tech/modules/course/repository/course_repo.dart';
import 'package:ed_tech/modules/home/model/course_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'course_state.dart';

class CourseCubit extends Cubit<CourseState> {
  final CourseRepo repo;

  CourseCubit({required this.repo}) : super(CourseInitial());

  
  Future<void> getCourses() async {
    emit(CourseProgress());
    try {
      final courses = await repo.getCourse(id: 0); 
      emit(CourseSuccess(courses: courses));
    } catch (e) {
      emit(CourseError(message: AppErrorState.getFriendlyErrorString(e)));
    }
  }


  Future<void> getCourseDetail(String courseId) async {
    emit(CourseDetailProgress());
    try {
      final courseDetail = await repo.getCourseDetail(courseId: courseId);
      emit(CourseDetailSuccess(courseDetail: courseDetail));
    } catch (e) {
      emit(CourseDetailError(message: AppErrorState.getFriendlyErrorString(e)));
    }
  }


  Future<void> cancelCourse(String courseId) async {
    emit(CourseCancellationProgress());
    try {
      final cancelledCourseId = await repo.cancelCourse(courseId: courseId);
      emit(CourseCancellationSuccess(courseId: cancelledCourseId));
    } catch (e) {
      emit(CourseCancellationError(message: AppErrorState.getFriendlyErrorString(e)));
    }
  }


  void reset() {
    emit(CourseInitial());
  }
}
