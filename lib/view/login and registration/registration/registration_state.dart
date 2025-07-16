part of 'registration_bloc.dart';

@immutable
sealed class RegistrationState {}

final class RegistrationInitial extends RegistrationState {}

final class RegistrationLoading extends RegistrationState {}

final class RegistrationSuccess extends RegistrationState {}

final class RegistrationFailure extends RegistrationState {
  final String error;

  RegistrationFailure(this.error);
}

final class PasswordVisibilityToggled extends RegistrationState {
  final bool showPassword;

  PasswordVisibilityToggled({required this.showPassword});
}
