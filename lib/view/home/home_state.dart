part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<GetPlace> places;
  final List<GetHotel> hotels;
  final List<GetTrips> trips;

  HomeLoaded({required this.places, required this.hotels, required this.trips});
}

class HomeFailure extends HomeState {
  final String error;

  HomeFailure(this.error);
}

class HomeSearchState extends HomeState {
  final List<GetPlace> searchResults;

  HomeSearchState({required this.searchResults});
}
