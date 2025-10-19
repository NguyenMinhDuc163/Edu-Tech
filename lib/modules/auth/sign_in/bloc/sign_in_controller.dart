import 'package:disposable_provider/disposable_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ed_tech/core/values/login_type.dart';
import 'package:ed_tech/modules/home/screen/home_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ed_tech/core/widgets/toast.dart';
import 'package:ed_tech/modules/auth/initial/screen/onboarding_screen.dart';
import 'package:ed_tech/modules/auth/sign_in/bloc/sign_in_cubit.dart';
import 'package:ed_tech/modules/auth/sign_in/bloc/sign_in_state.dart';

class SignInController extends Disposable {
  TextEditingController usernameController = TextEditingController(text: kDebugMode ? "student" : "");
  TextEditingController passwordController = TextEditingController(text: kDebugMode ? '111111' : "");
  ValueNotifier<bool> isSwitched = ValueNotifier(false);

  SignInController({Map<String, String>? prefillData}) {
    if (prefillData != null) {
      _prefillData(prefillData);
    }
  }

  void _prefillData(Map<String, String> data) {
    if (data['username'] != null) {
      usernameController.text = data['username']!;
    }
  }

  handleListener(BuildContext context, SignInState state) {
    if (state is SignInSuccess) {
      Navigator.pushNamed(context, HomeScreen.routeName);
    }

    if (state is SignInFailure) {
      showToastTop(message: 'login.failed'.tr());
    }
  }

  onSignIn(BuildContext context) {
    if (usernameController.text == '' || passwordController.text == '') {
      showToastTop(message: "sign_up.required_fields".tr());
    }
    context.read<SignInCubit>().onLoginStarted(
      username: usernameController.text,
      password: passwordController.text,
    );
  }

  onLogin(BuildContext context, LoginType type) {
    context.read<SignInCubit>().onLoginSocial();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
  }
}
