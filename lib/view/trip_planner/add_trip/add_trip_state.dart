part of 'add_trip_bloc.dart';

abstract class AddTripState {}

class AddTripInitial extends AddTripState {}

class TripDetailsUpdated extends AddTripState {
  final GetTrips addTrip;
  TripDetailsUpdated({required this.addTrip});
}

class TripSubmissionSuccess extends AddTripState {}

class TripSubmissionFailure extends AddTripState {
  final String error;
  TripSubmissionFailure({required this.error});
}
