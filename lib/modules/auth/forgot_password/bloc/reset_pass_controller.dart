import 'package:disposable_provider/disposable_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ed_tech/core/widgets/toast.dart';
import 'package:ed_tech/modules/auth/forgot_password/bloc/reset_pass_cubit.dart';
import 'package:ed_tech/modules/auth/forgot_password/bloc/reset_pass_state.dart';
import 'package:ed_tech/modules/auth/sign_in/screen/sign_in_screen.dart';
import 'package:ed_tech/core/theme/app_colors.dart';
import 'package:ed_tech/core/theme/app_text_styles.dart';

class ResetPassController extends Disposable {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  String username = '';

  ResetPassController({Map<String, String>? dataUser}) {
    if (dataUser != null) {
      username = dataUser['username'] ?? "";
    }
  }

  void onChangePassword(BuildContext context) {
    final oldPassword = oldPasswordController.text.trim();
    final newPassword = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      showToastTop(message: "Vui lòng điền đầy đủ thông tin");
      return;
    }

    if (newPassword.length < 6) {
      showToastTop(message: "Mật khẩu mới phải có ít nhất 6 ký tự");
      return;
    }

    if (newPassword != confirmPassword) {
      showToastTop(message: "Mật khẩu xác nhận không khớp");
      return;
    }

    if (oldPassword == newPassword) {
      showToastTop(message: "Mật khẩu mới phải khác mật khẩu cũ");
      return;
    }

    context.read<ResetPassCubit>().changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
  }

  void onResetPassword(BuildContext context) {
    if (passwordController.text == '' || confirmPasswordController.text == '') {
      showToastTop(message: "forgot_password.enter_password".tr());
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      showToastTop(message: "forgot_password.password_mismatch".tr());
      return;
    }
    context.read<ResetPassCubit>().onResetPassword(
      userName: username,
      password: confirmPasswordController.text,
    );
  }

  void handleListener(BuildContext context, ResetPassState state) {
    if (state is ResetPassSuccess) {
      _showSuccessDialog(context, state.message);
    }

    if (state is ResetPassFailure || state is ResetPassError) {
      final message = state is ResetPassError
          ? state.message
          : 'Đổi mật khẩu thất bại. Vui lòng thử lại.';
      showToastTop(message: message);
    }
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              SizedBox(width: 12),
              Text(
                'Thành công',
                style: AppTextStyles.textHeader3,
              ),
            ],
          ),
          content: Text(
            message,
            style: AppTextStyles.textContent1,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pop();
              },
              child: Text(
                'Đóng',
                style: AppTextStyles.textMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}
