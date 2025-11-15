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
