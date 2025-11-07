import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ed_tech/core/error_handling/app_error_state.dart';
import 'package:ed_tech/core/values/login_type.dart';
import 'package:ed_tech/modules/auth/sign_in/bloc/sign_in_state.dart';
import 'package:ed_tech/modules/auth/sign_in/repository/sign_in_repo.dart';
import 'package:ed_tech/modules/auth/sign_in/use_case/social_login.dart';

class SignInCubit extends Cubit<SignInState> {
  final SignInRepo repo;
  final SocialLogin socialLogin;

  SignInCubit({required this.repo, required this.socialLogin})
    : super(SignInInitial()) {
    _checkExistingToken();
  }

  Future<void> _checkExistingToken() async {
    final auth = repo.authService;

    Object? refreshError;
    final completer = Completer<void>();

    await auth.refreshTokenIfNeeded(
      onPerform: () {},
      onComplete: () => completer.complete(),
      onCompleteError: (e) {
        refreshError = e;
        completer.complete();
      },
    );
    await completer.future;

    final bool canGoHome =
        auth.accessToken != null &&
        auth.isAccessTokenExpired == false &&
        refreshError == null;

    if (canGoHome) {
      emit(SignInAuthenticated());
    } else {
      emit(SignInInitial());
    }
  }

  Future onLoginStarted({
    required String username,
    required String password,
  }) async {
    emit(SignInInProgress());
    try {
      await repo.login(username: username, password: password);
      emit(SignInSuccess());
    } catch (e) {
      final errorMessage = AppErrorState.getFriendlyErrorString(e);
      emit(SignInError(message: errorMessage.isNotEmpty ? errorMessage : 'login.error_occurred'.tr()));
    }
  }

  Future onLoginSocial() async {
    emit(SignInInProgress());
    try {
      // final res = await repo.signInWithGoogle();
      final res = await socialLogin.call(LoginType.google);
      if (res == true) {
        emit(SignInSuccess());
      } else if (res == null) {
        emit(SignInInitial());
      } else {
        emit(SignInFailure(message: 'login.failed'.tr()));
      }
    } catch (e) {
      final errorMessage = AppErrorState.getFriendlyErrorString(e);
      emit(SignInError(message: errorMessage.isNotEmpty ? errorMessage : 'login.error_occurred'.tr()));
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await repo.logout();
      emit(SignInInitial());
    } catch (e) {
      final errorMessage = AppErrorState.getFriendlyErrorString(e);
      emit(SignInError(message: errorMessage.isNotEmpty ? errorMessage : 'login.error_occurred'.tr()));
    }
  }
}
