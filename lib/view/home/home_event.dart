part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class HomeInitialEvent extends HomeEvent {}

class HomeSearchEvent extends HomeEvent {
  final String query;
  final List<GetPlace> places;

  HomeSearchEvent({required this.query, required this.places});
}
