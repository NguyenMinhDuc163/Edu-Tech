import 'package:equatable/equatable.dart';

sealed class SignUpState {}

class SignUpInitial extends SignUpState {}

class SignUpInProgress extends SignUpState {}

class SignUpSuccess extends SignUpState {}

class SignUpFailure extends SignUpState {
  final String? message;

  SignUpFailure({this.message});
}

class SignUpError extends SignUpState {
  final String? message;

  SignUpError({this.message});
}

class CheckUsernameInProgress extends SignUpState {}

class CheckUsernameSuccess extends SignUpState {
  final bool isAvailable;

  CheckUsernameSuccess({required this.isAvailable});
}

class CheckUsernameFailure extends SignUpState {
  final String? message;

  CheckUsernameFailure({this.message});
}

class CheckEmailInProgress extends SignUpState {}

class CheckEmailSuccess extends SignUpState {
  final bool isAvailable;

  CheckEmailSuccess({required this.isAvailable});
}

class CheckEmailFailure extends SignUpState {
  final String? message;

  CheckEmailFailure({this.message});
}
