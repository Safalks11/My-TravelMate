part of 'trip_main_bloc.dart';

@immutable
abstract class TripMainEvent {}

class FetchTripsEvent extends TripMainEvent {}

class UpdateTripStatusEvent extends TripMainEvent {
  final String tripId;
  final DateTime endDate;
  final int status;
  UpdateTripStatusEvent(this.tripId, this.endDate, this.status);
}

class UpdateTripEvent extends TripMainEvent {
  final GetTrips updatedTrip;

  UpdateTripEvent({required this.updatedTrip});
}
