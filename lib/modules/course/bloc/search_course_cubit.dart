import 'package:ed_tech/core/error_handling/app_error_state.dart';
import 'package:ed_tech/modules/course/model/search_course_result.dart';
import 'package:ed_tech/modules/course/model/search_history.dart';
import 'package:ed_tech/modules/course/repository/search_course_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_course_state.dart';

class SearchCourseCubit extends Cubit<SearchCourseState> {
  final SearchCourseRepo repo;
  List<SearchHistory> _cachedHistory = [];

  SearchCourseCubit({required this.repo}) : super(SearchCourseInitial());

  Future<void> loadSearchHistory() async {
    try {
      final history = await repo.getSearchHistory();
      _cachedHistory = history;
      emit(SearchHistoryLoaded(historyList: history));
    } catch (e) {
      emit(SearchCourseInitial());
    }
  }

  Future<void> searchCourses(String query) async {
    if (query.trim().isEmpty) {
      emit(SearchHistoryLoaded(historyList: _cachedHistory));
      return;
    }

    emit(SearchCourseProgress());
    try {
      final results = await repo.searchCourses(query);
      emit(SearchCourseSuccess(results: results));
    } catch (e) {
      emit(SearchCourseError(message: AppErrorState.getFriendlyErrorString(e)));
    }
  }

  Future<void> deleteHistory(String searchId) async {
    try {
      await repo.deleteSearchHistory(searchId);
      _cachedHistory.removeWhere((item) => item.searchId == searchId);
      emit(SearchHistoryLoaded(historyList: List.from(_cachedHistory)));
    } catch (e) {
      emit(SearchCourseError(message: AppErrorState.getFriendlyErrorString(e)));
    }
  }

  void reset() {
    emit(SearchHistoryLoaded(historyList: _cachedHistory));
  }
}
