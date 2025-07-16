import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../../controller/firebase_helper/firebase_helper.dart';
import '../../../model/trips_model.dart';

part 'trip_main_event.dart';
part 'trip_main_state.dart';

class TripMainBloc extends Bloc<TripMainEvent, TripMainState> {
  TripMainBloc() : super(TripMainInitial()) {
    on<FetchTripsEvent>(_onFetchTripsEvent);
    on<UpdateTripEvent>(_onUpdateTripEvent);
    on<UpdateTripStatusEvent>(_onUpdateTripStatusEvent);
  }
  FutureOr<void> _onFetchTripsEvent(
      FetchTripsEvent event, Emitter<TripMainState> emit) async {
    emit(TripLoadingState());

    try {
      FirebaseHelper firebaseHelper = FirebaseHelper();
      final data = await firebaseHelper.fetchUserData();
      List<GetTrips> trips = data['trips'];

      emit(TripsLoadedState(trips: trips));
    } catch (e, stacktrace) {
      print("Error: $e -  $stacktrace");
      emit(TripFailureState("Failed to load trips: $e"));
    }
  }

  FutureOr<void> _onUpdateTripEvent(
      UpdateTripEvent event, Emitter<TripMainState> emit) async {
    try {
      final FirebaseHelper firebaseHelper = FirebaseHelper();
      await firebaseHelper.updateTrip(event.updatedTrip);

      emit(TripUpdatedState(trip: event.updatedTrip));
    } catch (e) {}
  }

  FutureOr<void> _onUpdateTripStatusEvent(
      UpdateTripStatusEvent event, Emitter<TripMainState> emit) async {
    try {
      final FirebaseHelper firebaseHelper = FirebaseHelper();
      await firebaseHelper.updateTripStatus(
          event.tripId, event.endDate, event.status);
    } catch (e) {}
  }
}
