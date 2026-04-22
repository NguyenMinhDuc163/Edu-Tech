import 'package:disposable_provider/disposable_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ed_tech/core/widgets/toast.dart';
import 'package:ed_tech/modules/auth/sign_in/screen/sign_in_screen.dart';
import 'package:ed_tech/modules/auth/sign_up/bloc/sign_up_cubit.dart';
import 'package:ed_tech/modules/auth/sign_up/bloc/sign_up_state.dart';
import 'package:ed_tech/utils/helpers/validators.dart';

class SignUpController extends Disposable {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  ValueNotifier<bool> isSwitched = ValueNotifier(false);


  handleListener(BuildContext context, SignUpState state) {
    if (state is SignUpSuccess) {
      final prefillData = {'username': usernameController.text};

      Navigator.pushNamed(
        context,
        SignInScreen.routeName,
        arguments: prefillData,
      );
    }

    if (state is SignUpFailure) {
      showToastTop(message: 'sign_up.register_failure'.tr());
    }

    if (state is SignUpError) {
      showToastTop(message: state.message ?? 'sign_up.error_occurred'.tr());
    }
  }

  onSignUp(BuildContext context) {
    if (!_isValidateForm()) return;

    context.read<SignUpCubit>().onRegisterStarted(
      username: usernameController.text.trim(),
      password: passwordController.text.trim(),
      email: emailController.text.trim(),
    );
  }

  bool _isValidateForm() {
    if (usernameController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty) {
      showToastTop(message: "sign_up.required_fields".tr());
      return false;
    }
    if (passwordController.text.length < 6) {
      showToastTop(message: "sign_up.password_length".tr());
      return false;
    }
    if (!Validators.isValidEmail(emailController.text.trim())) {
      showToastTop(message: "sign_up.invalid_email".tr());
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    emailController.dispose();
  }
}
