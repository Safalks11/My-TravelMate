part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class LoginUserEvent extends LoginEvent {
  final String email;
  final String password;

  LoginUserEvent({required this.email, required this.password});
}

class TogglePasswordVisibilityEvent extends LoginEvent {
  final bool showPassword;
  TogglePasswordVisibilityEvent(this.showPassword);
}
