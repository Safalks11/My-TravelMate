part of 'drawer_bloc.dart';

@immutable
sealed class DrawerState {}

final class DrawerInitial extends DrawerState {}

final class UserDetails extends DrawerState {
  final String username;
  UserDetails(this.username);
}
