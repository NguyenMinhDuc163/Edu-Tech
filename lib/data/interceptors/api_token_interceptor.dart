import 'package:dio/dio.dart';
import 'package:ed_tech/core/constants/api_path.dart';

class ApiTokenInterceptor extends InterceptorsWrapper {
  final List<String> _apisRequiringToken = [

  ];

  bool shouldAddTokenToApi(String path) {
    for (String api in _apisRequiringToken) {
      if (path.contains(api)) {
        return true;
      }
    }
    return false;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (shouldAddTokenToApi(options.path)) {
      String updatedPath = options.path;
      final String urlToken = ApiPath.registerId;

      if (!updatedPath.contains(urlToken)) {
        updatedPath = '$updatedPath/$urlToken';
      }

      final RequestOptions updatedOptions = options.copyWith(path: updatedPath);
      super.onRequest(updatedOptions, handler);
    } else {
      super.onRequest(options, handler);
    }
  }
}
