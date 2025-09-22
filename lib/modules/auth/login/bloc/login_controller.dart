import 'package:disposable_provider/disposable_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ed_tech/core/values/login_type.dart';
import 'package:ed_tech/core/widgets/toast.dart';
import 'package:ed_tech/modules/auth/sign_in/bloc/sign_in_cubit.dart';
import 'package:ed_tech/modules/auth/sign_in/bloc/sign_in_state.dart';
import 'package:ed_tech/modules/home/screen/home_screen.dart';

class LoginController extends Disposable {
  onLogin(BuildContext context, LoginType type) {
    context.read<SignInCubit>().onLoginSocial();
  }

  handleListener(BuildContext context, SignInState state) {
    if (state is SignInSuccess) {
      Navigator.pushNamed(context, HomeScreen.routeName);
    }

    if (state is SignInFailure) {
      showToastTop(message: 'login.failed'.tr());
      throw Exception(state.message);

    }
  }

  @override
  void dispose() {}
}
