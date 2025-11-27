import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ed_tech/core/error_handling/app_error_state.dart';
import 'package:ed_tech/modules/home/bloc/home_state.dart';
import 'package:ed_tech/modules/home/repository/home_repo.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo repo;

  HomeCubit({required this.repo}) : super(CourseInitial());

  Future getProduct() async {
    emit(CourseProgress());
    try {
      final courses = await repo.getProduct();
      emit(CourseSuccess(courses: courses));
    } catch (e) {
      emit(CourseError(message: AppErrorState.getFriendlyErrorString(e)));
    }
  }

  Future getCourseStats({String? courseId}) async {
    emit(StatsProgress());
    try {
      final stats = await repo.getCourseStats(courseId: courseId);
      emit(StatsSuccess(stats: stats));
    } catch (e) {
      emit(StatsError(message: AppErrorState.getFriendlyErrorString(e)));
    }
  }
}
