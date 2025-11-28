import 'package:ed_tech/core/constants/api_path.dart';
import 'package:ed_tech/data/api_client.dart';
import 'package:ed_tech/data/models/request_method.dart';
import 'package:ed_tech/modules/course/model/search_course_result.dart';
import 'package:ed_tech/modules/course/model/search_history.dart';

class SearchCourseRepo {
  final ApiClient apiClient;

  SearchCourseRepo({required this.apiClient});

  Future<List<SearchCourseResult>> searchCourses(String query) async {
    final res = await apiClient.fetch(
      '${ApiPath.searchCourses}?q=$query',
      RequestMethod.get,
    );

    if (res.code != 200) {
      throw Exception('Failed to search courses: ${res.message}');
    }

    final List<dynamic> dataList = res.dataArray;
    return dataList.map((json) => SearchCourseResult.fromJson(json)).toList();
  }

  Future<List<SearchCourseResult>> filterCourses({
    String? query,
    double? minPrice,
    double? maxPrice,
    String? teacher,
    String? categoryId,
    int? minDuration,
    int? maxDuration,
  }) async {
    final queryParams = <String>[];

    if (query != null && query.isNotEmpty) {
      queryParams.add('q=$query');
    }
    if (minPrice != null) {
      queryParams.add('min_price=${minPrice.toInt()}');
    }
    if (maxPrice != null) {
      queryParams.add('max_price=${maxPrice.toInt()}');
    }
    if (teacher != null && teacher.isNotEmpty) {
      queryParams.add('teacher=${Uri.encodeComponent(teacher)}');
    }
    if (categoryId != null && categoryId.isNotEmpty) {
      queryParams.add('category_id=${Uri.encodeComponent(categoryId)}');
    }
    if (minDuration != null) {
      queryParams.add('min_duration=$minDuration');
    }
    if (maxDuration != null) {
      queryParams.add('max_duration=$maxDuration');
    }

    final queryString = queryParams.isNotEmpty ? '?${queryParams.join('&')}' : '';
    final res = await apiClient.fetch(
      '${ApiPath.searchCourses}$queryString',
      RequestMethod.get,
    );

    if (res.code != 200) {
      throw Exception('Failed to filter courses: ${res.message}');
    }

    final List<dynamic> dataList = res.dataArray;
    return dataList.map((json) => SearchCourseResult.fromJson(json)).toList();
  }

  Future<List<SearchHistory>> getSearchHistory() async {
    final res = await apiClient.fetch(
      ApiPath.searchHistory,
      RequestMethod.get,
    );

    if (res.code != 200) {
      throw Exception('Failed to get search history: ${res.message}');
    }

    final List<dynamic> dataList = res.dataArray;
    return dataList.map((json) => SearchHistory.fromJson(json)).toList();
  }

  Future<void> deleteSearchHistory(String searchId) async {
    final res = await apiClient.fetch(
      '${ApiPath.searchHistory}/$searchId',
      RequestMethod.delete,
    );

    if (res.code != 200) {
      throw Exception('Failed to delete search history: ${res.message}');
    }
  }
}
