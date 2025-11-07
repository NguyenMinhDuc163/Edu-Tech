sealed class SignInState {}

class SignInInitial extends SignInState {}

class SignInInProgress extends SignInState {}

class SignInSuccess extends SignInState {}

class SignInFailure extends SignInState {
  final String? message;

  SignInFailure({this.message});
}

class SignInError extends SignInState {
  final String? message;

  SignInError({this.message});
}

class SignInAuthenticated extends SignInState {}
