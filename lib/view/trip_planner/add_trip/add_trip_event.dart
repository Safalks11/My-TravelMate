part of 'add_trip_bloc.dart';

abstract class AddTripEvent {}

class SubmitTripEvent extends AddTripEvent {
  final GetTrips trip;
  SubmitTripEvent({required this.trip});
}
