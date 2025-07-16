import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'splash_screen_event.dart';
part 'splash_screen_state.dart';

class SplashScreenBloc extends Bloc<SplashScreenEvent, SplashScreenState> {
  SplashScreenBloc() : super(SplashScreenInitial()) {
    on<CheckAuthenticationEvent>((event, emit) async {
      emit(SplashScreenLoading());
      await Future.delayed(const Duration(seconds: 2));
      await emit.forEach<User?>(FirebaseAuth.instance.authStateChanges(),
          onData: (user) {
            if (user == null) {
              return SplashScreenNavigateToLogin();
            } else {
              return SplashScreenNavigateToHome();
            }
          },
          onError: (_, __) => SplashScreenError("Something went wrong"));
    });
  }
}
