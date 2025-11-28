import 'package:ed_tech/core/error_handling/app_error_state.dart';
import 'package:ed_tech/modules/course/model/search_course_result.dart';
import 'package:ed_tech/modules/course/repository/search_course_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'filter_course_state.dart';

class FilterCourseCubit extends Cubit<FilterCourseState> {
  final SearchCourseRepo repo;

  FilterCourseCubit({required this.repo}) : super(FilterCourseInitial());

  Future<void> filterCourses({
    List<String>? categories,
    List<String>? durations,
    double? minPrice,
    double? maxPrice,
  }) async {
    emit(FilterCourseProgress());
    try {
      int? minDuration;
      int? maxDuration;

      if (durations != null && durations.isNotEmpty) {
        final parsedDurations = durations.map((d) => _parseDuration(d)).toList();
        minDuration = parsedDurations.map((e) => e.$1).reduce((a, b) => a < b ? a : b);
        maxDuration = parsedDurations.map((e) => e.$2).reduce((a, b) => a > b ? a : b);
      }

      String? categoryId;
      if (categories != null && categories.isNotEmpty) {
        categoryId = categories.first;
      }

      final results = await repo.filterCourses(
        minPrice: minPrice,
        maxPrice: maxPrice,
        categoryId: categoryId,
        minDuration: minDuration,
        maxDuration: maxDuration,
      );

      emit(FilterCourseSuccess(results: results));
    } catch (e) {
      emit(FilterCourseError(message: AppErrorState.getFriendlyErrorString(e)));
    }
  }

  (int, int) _parseDuration(String duration) {
    final parts = duration.split('-');
    if (parts.length == 2) {
      final min = int.tryParse(parts[0].trim().replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      final max = int.tryParse(parts[1].trim().replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      return (min, max);
    }
    return (0, 100);
  }
}
