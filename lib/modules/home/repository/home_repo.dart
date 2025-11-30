import 'package:ed_tech/core/constants/api_path.dart';
import 'package:ed_tech/data/api_client.dart';
import 'package:ed_tech/data/models/request_method.dart';
import 'package:ed_tech/modules/home/model/course_response.dart';
import 'package:ed_tech/modules/home/model/course_stats_response.dart';
import 'package:ed_tech/modules/home/model/learning_progress_response.dart';
import 'package:ed_tech/data/services/user_service.dart';

class HomeRepo {
  final ApiClient apiClient;

  HomeRepo({required this.apiClient});

  Future<List<DataCourse>> getProduct() async {
    final userId = UserService.instance.userData?.id ?? '1';
    final res = await apiClient.fetch(
      '${ApiPath.hybridRecommendations}/$userId',
      RequestMethod.get,
    );

    if (res.code != 200) {
      throw Exception('Failed to fetch courses: ${res.message}');
    }

    final List<dynamic> dataList = res.dataArray;
    return dataList.map((json) => DataCourse.fromJson(json)).toList();
  }

  Future<CourseStatsData> getCourseStats({String? courseId}) async {
    final Map<String, String> searchParams = {};
    if (courseId != null) {
      searchParams['courseId'] = courseId;
    }

    final res = await apiClient.fetch(
      ApiPath.courseStats,
      RequestMethod.get,
      searchParams: searchParams.isEmpty ? null : searchParams,
    );

    if (res.code != 200) {
      throw Exception('Failed to fetch course stats: ${res.message}');
    }

    return CourseStatsData.fromJson(res.data);
  }

  Future<LearningProgressData> getLearningProgress() async {
    final res = await apiClient.fetch(
      ApiPath.learningProgress,
      RequestMethod.get,
    );

    if (res.code != 200) {
      throw Exception('Failed to fetch learning progress: ${res.message}');
    }

    return LearningProgressData.fromJson(res.data);
  }
}
