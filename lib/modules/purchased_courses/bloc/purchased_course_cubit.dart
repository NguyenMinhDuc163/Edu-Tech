import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ed_tech/core/error_handling/app_error_state.dart';
import 'package:ed_tech/modules/purchased_courses/bloc/purchased_course_state.dart';
import 'package:ed_tech/modules/purchased_courses/repository/purchased_course_repo.dart';

class PurchasedCourseCubit extends Cubit<PurchasedCourseState> {
  final PurchasedCourseRepo repo;

  PurchasedCourseCubit({required this.repo}) : super(PurchasedCourseInitial());

  Future<void> getPurchasedCourses() async {
    emit(PurchasedCourseProgress());
    try {
      final courses = await repo.getPurchasedCourses();
      emit(PurchasedCourseSuccess(courses: courses));
    } catch (e) {
      emit(PurchasedCourseError(
          message: AppErrorState.getFriendlyErrorString(e)));
    }
  }
}
