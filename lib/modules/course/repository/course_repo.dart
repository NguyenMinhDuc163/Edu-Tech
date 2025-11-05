import 'package:ed_tech/core/constants/api_path.dart';
import 'package:ed_tech/data/api_client.dart';
import 'package:ed_tech/data/models/request_method.dart';
import 'package:ed_tech/modules/home/model/course_response.dart';
import 'package:ed_tech/modules/course/model/detail_course.dart';

class CourseRepo {
  final ApiClient apiClient;

  CourseRepo({required this.apiClient});

  Future<List<DataCourse>> getCourse({required int id}) async {
    final res = await apiClient.fetch(ApiPath.publicCourse, RequestMethod.get);

    if (res.code != 200) {
      throw Exception('Failed to fetch courses: ${res.message}');
    }

    final List<dynamic> dataList = res.dataArray;
    return dataList.map((json) => DataCourse.fromJson(json)).toList();
  }

  Future<DataData> getCourseDetail({required String courseId}) async {
    final res = await apiClient.fetch(
      '${ApiPath.publicCourse}/$courseId',
      RequestMethod.get,
    );

    if (res.code != 200) {
      throw Exception('Failed to fetch course detail: ${res.message}');
    }

    return DataData.fromJson(res.data);
  }
}
