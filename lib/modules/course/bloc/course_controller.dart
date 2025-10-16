import 'package:disposable_provider/disposable_provider.dart';
import 'package:ed_tech/core/data_types.dart';

class CourseController extends Disposable {
  final BoolVs isFilterVisible = BoolVs(false);
  final StringVs searchQuery = StringVs('');
  final BoolVs isCategorySelected = BoolVs(false);
  final IntVs selectedCategoryIndex = IntVs(0);

  void toggleFilter() {
    isFilterVisible.value = !isFilterVisible.value;
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void selectCategory(int index) {
    selectedCategoryIndex.value = index;
    isCategorySelected.value = true;
  }

  void clearSearch() {
    searchQuery.value = '';
  }

  @override
  void dispose() {
    isFilterVisible.dispose();
    searchQuery.dispose();
    isCategorySelected.dispose();
    selectedCategoryIndex.dispose();
  }
}
