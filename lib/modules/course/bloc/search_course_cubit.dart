import 'dart:async';
import 'package:ed_tech/core/error_handling/app_error_state.dart';
import 'package:ed_tech/modules/course/model/search_course_result.dart';
import 'package:ed_tech/modules/course/model/search_history.dart';
import 'package:ed_tech/modules/course/model/autocomplete_suggestion.dart';
import 'package:ed_tech/modules/course/repository/search_course_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_course_state.dart';

class SearchCourseCubit extends Cubit<SearchCourseState> {
  final SearchCourseRepo repo;
  List<SearchHistory> _cachedHistory = [];
  Timer? _autocompleteDebounce;

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

  Future<void> getAutocompleteSuggestions(String query) async {
    if (_autocompleteDebounce?.isActive ?? false) _autocompleteDebounce!.cancel();

    if (query.trim().length < 2) {
      emit(SearchHistoryLoaded(historyList: _cachedHistory));
      return;
    }

    _autocompleteDebounce = Timer(const Duration(milliseconds: 300), () async {
      try {
        final suggestions = await repo.getAutocompleteSuggestions(query);
        emit(AutocompleteSuggestionsLoaded(suggestions: suggestions));
      } catch (e) {
        emit(SearchHistoryLoaded(historyList: _cachedHistory));
      }
    });
  }

  void dispose() {
    _autocompleteDebounce?.cancel();
  }
}
