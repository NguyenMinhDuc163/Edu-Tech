import 'package:ed_tech/core/constants/api_path.dart';
import 'package:ed_tech/data/api_client.dart';
import 'package:ed_tech/data/models/request_method.dart';
import 'package:ed_tech/modules/purchased_courses/model/purchased_course_response.dart';

class PurchasedCourseRepo {
  final ApiClient apiClient;

  PurchasedCourseRepo({required this.apiClient});

  Future<List<PurchasedCourse>> getPurchasedCourses() async {
    final res = await apiClient.fetch(
      ApiPath.purchasedCourses,
      RequestMethod.get,
    );

    if (res.code != 200) {
      throw Exception('Failed to fetch purchased courses: ${res.message}');
    }

    final List<dynamic> dataList = res.dataArray;
    return dataList.map((json) => PurchasedCourse.fromJson(json)).toList();
  }
}
