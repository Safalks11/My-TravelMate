import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../controller/firebase_helper/firebase_helper.dart';

part 'registration_event.dart';
part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc() : super(RegistrationInitial()) {
    on<RegisterUserEvent>(_onRegisterUser);
    on<TogglePasswordVisibilityEvent>(_onTogglePassword);
  }

  FutureOr<void> _onRegisterUser(
      RegisterUserEvent event, Emitter<RegistrationState> emit) async {
    emit(RegistrationLoading());
    try {
      final firebaseHelper = FirebaseHelper();
      final errorMessage = await firebaseHelper.register(
          regEmail: event.email,
          regPass: event.password,
          regUsername: event.username);

      if (errorMessage == null) {
        emit(RegistrationSuccess());
      } else {
        emit(RegistrationFailure(errorMessage));
      }
    } catch (e) {
      emit(RegistrationFailure("An unexpected error occurred."));
    }
  }

  FutureOr<void> _onTogglePassword(
      TogglePasswordVisibilityEvent event, Emitter<RegistrationState> emit) {
    emit(PasswordVisibilityToggled(showPassword: event.showPassword));
  }
}
