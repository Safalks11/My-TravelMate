import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:main_project/model/items_model.dart';
import 'package:meta/meta.dart';

import '../../../../controller/firebase_helper/firebase_helper.dart';

part 'trip_items_event.dart';
part 'trip_items_state.dart';

class TripItemsBloc extends Bloc<TripItemsEvent, TripItemsState> {
  TripItemsBloc() : super(TripItemsInitial()) {
    on<LoadItems>(_onLoadItems);
    on<AddItem>(_onAddItem);
    on<UpdatePackedStatus>(_onUpdatePackedStatus);
    on<DeleteItem>(_onDeleteItem);
  }
  Future<void> _onLoadItems(
      LoadItems event, Emitter<TripItemsState> emit) async {
    emit(ItemsLoading());

    try {
      final FirebaseHelper firebaseHelper = FirebaseHelper();

      final items = await firebaseHelper.getItems(event.tripId);
      emit(ItemsLoaded(items));
    } catch (e) {
      emit(ItemsError("Failed to load items: $e"));
    }
  }

  Future<void> _onAddItem(AddItem event, Emitter<TripItemsState> emit) async {
    emit(ItemsLoading());
    try {
      final FirebaseHelper firebaseHelper = FirebaseHelper();
      await firebaseHelper.addItem(event.tripId, event.item);

      add(LoadItems(event.tripId)); // Refresh items
    } catch (e) {
      emit(ItemsError("Failed to add item: $e"));
    }
  }

  FutureOr<void> _onUpdatePackedStatus(
      UpdatePackedStatus event, Emitter<TripItemsState> emit) async {
    try {
      final FirebaseHelper firebaseHelper = FirebaseHelper();
      await firebaseHelper.updatePackedStatus(
          event.tripId, event.itemId, event.packed);
      add(LoadItems(event.tripId)); // Refresh items
    } catch (e) {}
  }

  FutureOr<void> _onDeleteItem(
      DeleteItem event, Emitter<TripItemsState> emit) async {
    emit(ItemsLoading());
    try {
      final FirebaseHelper firebaseHelper = FirebaseHelper();
      await firebaseHelper.deleteItem(event.tripId, event.itemId);
      add(LoadItems(event.tripId));
    } catch (e) {}
  }
}
