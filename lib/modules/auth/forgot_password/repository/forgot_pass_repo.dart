import 'package:ed_tech/core/constants/api_path.dart';
import 'package:ed_tech/data/api_client.dart';
import 'package:ed_tech/data/models/request_method.dart';

class ForgotPassRepo {
  final ApiClient apiClient;

  ForgotPassRepo({required this.apiClient});

  Future<String> forgotPasswordByEmail({required String email}) async {
    final res = await apiClient.fetch(
      ApiPath.forgotPassword,
      RequestMethod.post,
      rawData: {"email": email},
    );

    if (res.code != 200) {
      throw Exception(res.message);
    }

    try {
      final dynamic data = res.data;
      if (data is Map<String, dynamic>) {
        return data['message'] as String? ?? 'Đã gửi email đặt lại mật khẩu';
      } else if (data is String) {
        return data;
      }
    } catch (e) {
      return 'Đã gửi email đặt lại mật khẩu';
    }

    return 'Đã gửi email đặt lại mật khẩu';
  }

  Future<bool> sendOPT({required String username}) async {
    final res = await apiClient.fetch(
      ApiPath.forgotPassword,
      RequestMethod.post,
      rawData: {"username": username, "verification": "4 digit OTP"},
    );
    String status = res.json['status'];
    return status == 'ok' && res.code == 200;
  }

  Future<bool> checkUserName({required String username}) async {
    final res = await apiClient.fetch(
      ApiPath.checkUserName,
      RequestMethod.post,
      rawData: {"username": username},
    );
    return res.code == 200 && res.json["result"] == false;
  }

  Future<bool> verifyOtp({
    required String otp,
    required String userName,
  }) async {
    final res = await apiClient.fetch(
      ApiPath.verifyOtp,
      RequestMethod.post,
      rawData: {"username": userName, "enteredOtp": otp, "expiresInMins": 30},
    );
    return res.code == 200;
  }

  Future<bool> resetPassword({
    required String userName,
    required String password,
  }) async {
    final res = await apiClient.fetch(
      ApiPath.resetPassword,
      RequestMethod.post,
      rawData: {"username": userName, "password": password},
    );
    String status = res.json['status'];
    return status == 'ok';
  }

  Future<String> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final res = await apiClient.fetch(
      ApiPath.changePassword,
      RequestMethod.post,
      rawData: {
        "oldPassword": oldPassword,
        "newPassword": newPassword,
      },
    );

    if (res.code != 200) {
      throw Exception(res.message);
    }

    try {
      final dynamic data = res.data;
      if (data is Map<String, dynamic>) {
        return data['message'] as String? ?? 'Đổi mật khẩu thành công';
      } else if (data is String) {
        return data;
      }
    } catch (e) {
      return 'Đổi mật khẩu thành công';
    }

    return 'Đổi mật khẩu thành công';
  }
}
