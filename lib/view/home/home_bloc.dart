import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:main_project/model/trips_model.dart';
import 'package:meta/meta.dart';

import '../../controller/firebase_helper/firebase_helper.dart';
import '../../model/places&hotels_model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeInitialEvent>(_onHomeInitialEvent);
    on<HomeSearchEvent>(_onHomeSearchEvent);
  }

  FutureOr<void> _onHomeInitialEvent(
      HomeInitialEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());

    try {
      FirebaseHelper firebaseHelper = FirebaseHelper();

      final data = await firebaseHelper.fetchUserData();
      List<GetPlace> places = data['places'];
      List<GetHotel> hotels = data['hotels'];
      List<GetTrips> trips = data['trips'];

      emit(HomeLoaded(places: places, hotels: hotels, trips: trips));
    } catch (e, stacktrace) {
      print("Error: $e -  $stacktrace");
      emit(HomeFailure("Failed to load data: $e"));
    }
  }

  void _onHomeSearchEvent(HomeSearchEvent event, Emitter<HomeState> emit) {
    if (event.query.isEmpty) {
      emit(HomeSearchState(searchResults: event.places));
    } else {
      List<GetPlace> filteredPlaces = event.places
          .where((place) =>
              place.title.toLowerCase().contains(event.query.toLowerCase()))
          .toList();
      emit(HomeSearchState(searchResults: filteredPlaces));
    }
  }
}
