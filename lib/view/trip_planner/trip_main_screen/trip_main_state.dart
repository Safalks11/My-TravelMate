part of 'trip_main_bloc.dart';

@immutable
sealed class TripMainState {}

final class TripMainInitial extends TripMainState {}

class TripsLoadedState extends TripMainState {
  final List<GetTrips> trips;

  TripsLoadedState({required this.trips});
}

class TripLoadingState extends TripMainState {}

class TripFailureState extends TripMainState {
  final String error;

  TripFailureState(this.error);
}

class TripUpdatedState extends TripMainState {
  final GetTrips trip;
  TripUpdatedState({required this.trip});
}
