part of 'registration_bloc.dart';

@immutable
sealed class RegistrationEvent {}

class RegisterUserEvent extends RegistrationEvent {
  final String email;
  final String username;
  final String password;

  RegisterUserEvent(
      {required this.email, required this.username, required this.password});
}

class TogglePasswordVisibilityEvent extends RegistrationEvent {
  // New event for password toggle
  final bool showPassword;
  TogglePasswordVisibilityEvent(this.showPassword);
}
