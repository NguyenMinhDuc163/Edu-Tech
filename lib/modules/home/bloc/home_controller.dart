import 'package:disposable_provider/disposable_provider.dart';
import 'package:ed_tech/core/data_types.dart';

class HomeController extends Disposable {
  final BoolVs isSearchVisible = BoolVs(false);
  final StringVs searchQuery = StringVs('');
  final BoolVs isFilterVisible = BoolVs(false);
  final BoolVs isNotificationVisible = BoolVs(false);

  void toggleSearch() {
    isSearchVisible.value = !isSearchVisible.value;
    if (!isSearchVisible.value) {
      searchQuery.value = '';
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void toggleFilter() {
    isFilterVisible.value = !isFilterVisible.value;
  }

  void toggleNotification() {
    isNotificationVisible.value = !isNotificationVisible.value;
  }

  @override
  void dispose() {
    isSearchVisible.dispose();
    searchQuery.dispose();
    isFilterVisible.dispose();
    isNotificationVisible.dispose();
  }
}
