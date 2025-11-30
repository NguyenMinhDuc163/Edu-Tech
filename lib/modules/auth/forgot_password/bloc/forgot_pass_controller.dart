import 'package:disposable_provider/disposable_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ed_tech/core/widgets/toast.dart';
import 'package:ed_tech/modules/auth/forgot_password/bloc/forgot_pass_cubit.dart';
import 'package:ed_tech/modules/auth/forgot_password/bloc/forgot_pass_state.dart';
import 'package:ed_tech/modules/auth/sign_in/screen/sign_in_screen.dart';
import 'package:ed_tech/core/theme/app_colors.dart';
import 'package:ed_tech/core/theme/app_text_styles.dart';

class ForgotPassController extends Disposable {
  TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  void onSendResetPasswordEmail(BuildContext context) {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      showToastTop(message: "login.enter_data_to_continue".tr());
      return;
    }

    if (!isValidEmail(email)) {
      showToastTop(message: "Vui lòng nhập email hợp lệ");
      return;
    }

    context.read<ForgotPassCubit>().forgotPasswordByEmail(email: email);
  }

  void handleListener(BuildContext context, ForgotPassState state) {
    if (state is ForgotPassSuccess) {
      _showSuccessDialog(context, state.message);
    }

    if (state is ForgotPassFailure || state is ForgotPassError) {
      final message = state is ForgotPassError
          ? state.message
          : 'Gửi email thất bại. Vui lòng thử lại.';
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
                Navigator.of(context).pushNamedAndRemoveUntil(
                  SignInScreen.routeName,
                  (route) => false,
                );
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
}
