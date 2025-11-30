import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ed_tech/core/error_handling/app_error_state.dart';
import 'package:ed_tech/modules/auth/forgot_password/bloc/reset_pass_state.dart';
import 'package:ed_tech/modules/auth/forgot_password/repository/forgot_pass_repo.dart';

class ResetPassCubit extends Cubit<ResetPassState> {
  final ForgotPassRepo repo;

  ResetPassCubit({required this.repo}) : super(ResetPassInitial());
  Future onResetPassword({required String userName, required String password}) async {
    emit(ResetPassInProgress());
    try {
      final res = await repo.resetPassword(userName: userName, password: password);
      if (res) {
        emit(ResetPassSuccess());
      } else {
        emit(ResetPassFailure());
      }
    } catch (e) {
      emit(ResetPassError(message: AppErrorState.getFriendlyErrorString(e)));
      throw Exception(e);
    }
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    emit(ResetPassInProgress());
    try {
      final message = await repo.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
      emit(ResetPassSuccess(message: message));
    } catch (e) {
      emit(ResetPassError(message: AppErrorState.getFriendlyErrorString(e)));
    }
  }
}