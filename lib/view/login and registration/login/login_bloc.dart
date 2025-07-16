import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../controller/firebase_helper/firebase_helper.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginUserEvent>(_onLoginUser);
    on<TogglePasswordVisibilityEvent>(_onTogglePassword);
  }

  FutureOr<void> _onLoginUser(
      LoginUserEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoading());

    final firebaseHelper = FirebaseHelper();

    try {
      // Admin Login Check
      if (event.email.trim() == 'admin@gmail.com' &&
          event.password.trim() == 'Admin@123') {
        await Future.delayed(const Duration(seconds: 1));
        emit(AdminLoginSuccess());
        return;
      }

      // Firebase Authentication
      final errorMessage = await firebaseHelper.login(
        loginEmail: event.email.trim(),
        loginPass: event.password.trim(),
      );

      if (errorMessage == null) {
        emit(LoginSuccess());
      } else {
        emit(LoginFailure(errorMessage)); // Explicit failure on error
      }
    } catch (e) {
      emit(LoginFailure("Login failed. Please try again."));
    }
  }

  FutureOr<void> _onTogglePassword(
      TogglePasswordVisibilityEvent event, Emitter<LoginState> emit) {
    emit(PasswordVisibilityToggled(showPassword: event.showPassword));
  }
}
