import 'package:disposable_provider/disposable_provider.dart';
import 'package:ed_tech/core/data_types.dart';

class SearchCourseController extends Disposable {
  final StringVs searchQuery = StringVs('');
  final BoolVs isSearching = BoolVs(false);

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void clearSearch() {
    searchQuery.value = '';
  }

  @override
  void dispose() {
    searchQuery.dispose();
    isSearching.dispose();
  }
}
