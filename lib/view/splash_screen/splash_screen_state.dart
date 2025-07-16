part of 'splash_screen_bloc.dart';

@immutable
sealed class SplashScreenState {}

final class SplashScreenInitial extends SplashScreenState {}

final class SplashScreenLoading extends SplashScreenState {}

final class SplashScreenNavigateToHome extends SplashScreenState {}

final class SplashScreenNavigateToLogin extends SplashScreenState {}

final class SplashScreenError extends SplashScreenState {
  final String error;
  SplashScreenError(this.error);
}
