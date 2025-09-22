import 'package:ed_tech/core/constants/api_path.dart';
import 'package:ed_tech/data/api_client.dart';
import 'package:ed_tech/data/models/request_method.dart';
import 'package:ed_tech/modules/home/model/product_response.dart';

class HomeRepo {
  final ApiClient apiClient;

  HomeRepo({required this.apiClient});

  Future<bool> getProduct() async {
    final res = await apiClient.fetch(
      ApiPath.products,
      RequestMethod.get,
      searchParams: {"limit": "10"},
    );
    ProductResponse productResponse = ProductResponse.fromJson(res.json);
    print(productResponse);
    return res.code == 200;
  }
}
