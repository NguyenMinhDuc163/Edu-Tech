import 'package:ed_tech/core/constants/api_path.dart';
import 'package:ed_tech/data/api_client.dart';
import 'package:ed_tech/data/models/request_method.dart';
import 'package:ed_tech/modules/home/model/course_response.dart';
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
}
