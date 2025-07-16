part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {}

final class AdminLoginSuccess extends LoginState {}

final class LoginFailure extends LoginState {
  final String error;
  LoginFailure(this.error);
}

final class PasswordVisibilityToggled extends LoginState {
  final bool showPassword;
  PasswordVisibilityToggled({required this.showPassword});
}
