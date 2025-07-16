import 'package:bloc/bloc.dart';
import 'package:main_project/model/trips_model.dart';

import '../../../controller/firebase_helper/firebase_helper.dart';

part 'add_trip_event.dart';
part 'add_trip_state.dart';

class AddTripBloc extends Bloc<AddTripEvent, AddTripState> {
  AddTripBloc() : super(AddTripInitial()) {
    on<SubmitTripEvent>(_onSubmitTrip);
  }
  Future<void> _onSubmitTrip(
      SubmitTripEvent event, Emitter<AddTripState> emit) async {
    try {
      FirebaseHelper firebaseHelper = FirebaseHelper();

      await firebaseHelper.addTrip(event.trip);
      emit(TripSubmissionSuccess());
    } catch (e) {
      emit(TripSubmissionFailure(error: e.toString()));
    }
  }
}
