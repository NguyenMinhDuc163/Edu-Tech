import 'package:ed_tech/core/constants/api_path.dart';
import 'package:ed_tech/data/api_client.dart';
import 'package:ed_tech/data/models/request_method.dart';
import 'package:ed_tech/modules/home/model/course_response.dart';

class HomeRepo {
  final ApiClient apiClient;

  HomeRepo({required this.apiClient});

  Future<List<DataCourse>> getProduct() async {
    final res = await apiClient.fetch(ApiPath.publicCourse, RequestMethod.get);

    if (res.code != 200) {
      throw Exception('Failed to fetch courses: ${res.message}');
    }

    CourseResponse courseResponse = CourseResponse.fromJson(res.json);
    return courseResponse.data?.data ?? [];
  }
}
