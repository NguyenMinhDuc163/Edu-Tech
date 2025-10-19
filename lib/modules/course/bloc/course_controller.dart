import 'package:disposable_provider/disposable_provider.dart';
import 'package:ed_tech/core/data_types.dart';

class CourseController extends Disposable {
  final StringVs searchQuery = StringVs('');
  final BoolVs isSearchVisible = BoolVs(false);

  final BoolVs isFilterVisible = BoolVs(false);
  final ListVs<String> selectedCategories = ListVs<String>([]);
  final ListVs<String> selectedDurations = ListVs<String>([]);
  final DoubleVs selectedMinPrice = DoubleVs(0.0);
  final DoubleVs selectedMaxPrice = DoubleVs(500.0);

  final StringVs selectedCategory = StringVs('All');

  final BoolVs isGridView = BoolVs(false);
  final BoolVs isSortAscending = BoolVs(true);

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void toggleSearch() {
    isSearchVisible.value = !isSearchVisible.value;
    if (!isSearchVisible.value) {
      searchQuery.value = '';
    }
  }

  void toggleFilter() {
    isFilterVisible.value = !isFilterVisible.value;
  }

  void updateSelectedCategory(String category) {
    selectedCategory.value = category;
  }

  void updateFilter({
    required List<String> categories,
    required List<String> durations,
    required double minPrice,
    required double maxPrice,
  }) {
    selectedCategories.value = categories;
    selectedDurations.value = durations;
    selectedMinPrice.value = minPrice;
    selectedMaxPrice.value = maxPrice;
  }

  void clearFilter() {
    selectedCategories.value = [];
    selectedDurations.value = [];
    selectedMinPrice.value = 0.0;
    selectedMaxPrice.value = 500.0;
  }

  void toggleGridView() {
    isGridView.value = !isGridView.value;
  }

  void toggleSortOrder() {
    isSortAscending.value = !isSortAscending.value;
  }

  @override
  void dispose() {
    searchQuery.dispose();
    isSearchVisible.dispose();
    isFilterVisible.dispose();
    selectedCategories.dispose();
    selectedDurations.dispose();
    selectedMinPrice.dispose();
    selectedMaxPrice.dispose();
    selectedCategory.dispose();
    isGridView.dispose();
    isSortAscending.dispose();
  }
}
