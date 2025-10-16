import 'package:dio/dio.dart';
import 'package:ed_tech/core/constants/api_path.dart';
import 'package:ed_tech/data/services/auth_service.dart';

class ApiTokenInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Chỉ thêm Bearer token vào header cho TẤT CẢ APIs
    final String? accessToken = AuthService.instance.accessToken;
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    super.onRequest(options, handler);
  }
}
