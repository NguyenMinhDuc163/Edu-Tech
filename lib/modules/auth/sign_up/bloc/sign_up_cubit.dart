import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ed_tech/core/error_handling/app_error_state.dart';
import 'package:ed_tech/modules/auth/sign_up/bloc/sign_up_state.dart';
import 'package:ed_tech/modules/auth/sign_up/repository/sign_up_repo.dart';
import 'package:ed_tech/utils/helpers/validators.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit({required this.repo}) : super(SignUpInitial()) {
    // lay tu repo => co token => emit AuthGenToken
    // tach dang nhap dang ky
    // Viet interceptor de tu + vào url
    // throw messgae khi call api lõi
    // xu ly luu token o repo
    // them messgae neu loi
  }

  final SignUpRepo repo;
  Timer? _emailDebounceTimer;
  Timer? _usernameDebounceTimer;

  Future onRegisterStarted({
    required String username,
    required String password,
    required String email,
  }) async {
    emit(SignUpInProgress());

    try {
      final res = await repo.register(username: username, password: password, email: email);
      if (res) {
        emit(SignUpSuccess());
      } else {
        emit(SignUpFailure(message: 'sign_up.invalid_registration_info'.tr()));
      }
    } catch (e) {
      final errorMessage = AppErrorState.getFriendlyErrorString(e);
      emit(SignUpError(message: errorMessage.isNotEmpty ? errorMessage : 'sign_up.error_occurred'.tr()));
      return;
    }
  }

  void onUsernameChanged(String username) {
    final trimmed = username.trim();

    _usernameDebounceTimer?.cancel();

    if (trimmed.length < 3) {
      return;
    }

    _usernameDebounceTimer = Timer(const Duration(milliseconds: 500), () async {
      await checkUserName(username: trimmed);
    });
  }

  Future checkUserName({required String username}) async {
    emit(CheckUsernameInProgress());

    try {
      final res = await repo.checkUserName(username: username);
      if (res) {
        emit(CheckUsernameSuccess(isAvailable: true));
      } else {
        emit(CheckUsernameSuccess(isAvailable: false));
      }
    } catch (e) {
      final errorMessage = AppErrorState.getFriendlyErrorString(e);
      emit(CheckUsernameFailure(message: errorMessage.isNotEmpty ? errorMessage : 'sign_up.check_username_failed'.tr()));
      return;
    }
  }

  void onEmailChanged(String email) {
    final trimmed = email.trim();

    _emailDebounceTimer?.cancel();

    if (trimmed.length < 3 || !Validators.isValidEmail(trimmed)) {
      return;
    }

    _emailDebounceTimer = Timer(const Duration(milliseconds: 500), () async {
      await checkEmail(email: trimmed);
    });
  }

  Future checkEmail({required String email}) async {
    emit(CheckEmailInProgress());

    try {
      final res = await repo.checkEmail(email: email);
      if (res) {
        emit(CheckEmailSuccess(isAvailable: true));
      } else {
        emit(CheckEmailSuccess(isAvailable: false));
      }
    } catch (e) {
      final errorMessage = AppErrorState.getFriendlyErrorString(e);
      emit(CheckEmailFailure(message: errorMessage.isNotEmpty ? errorMessage : 'sign_up.check_email_failed'.tr()));
      return;
    }
  }
}
