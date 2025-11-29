import 'package:disposable_provider/disposable_provider.dart';
import 'package:ed_tech/core/data_types.dart';
import 'package:ed_tech/modules/assessment/models/leaderboard_model.dart';

class LeaderboardController extends Disposable {
  final BoolVs isLoading = BoolVs(false);
  final BoolVs isLoadingMore = BoolVs(false);
  final ListVs<LeaderboardItem> leaderboardItems = ListVs<LeaderboardItem>([]);
  final StringVs errorMessage = StringVs('');
  final IntVs currentPage = IntVs(1);
  final IntVs totalPages = IntVs(1);

  void setLoading(bool loading) {
    isLoading.value = loading;
  }

  void setLoadingMore(bool loading) {
    isLoadingMore.value = loading;
  }

  void setLeaderboardItems(List<LeaderboardItem> items, {bool append = false}) {
    if (append) {
      leaderboardItems.addAll(items);
    } else {
      leaderboardItems.value = items;
    }
  }

  void setError(String message) {
    errorMessage.value = message;
  }

  void clearError() {
    errorMessage.value = '';
  }

  void setCurrentPage(int page) {
    currentPage.value = page;
  }

  void setTotalPages(int pages) {
    totalPages.value = pages;
  }

  void reset() {
    leaderboardItems.clear();
    currentPage.value = 1;
    totalPages.value = 1;
    clearError();
  }

  @override
  void dispose() {
    isLoading.dispose();
    isLoadingMore.dispose();
    leaderboardItems.dispose();
    errorMessage.dispose();
    currentPage.dispose();
    totalPages.dispose();
  }
}
