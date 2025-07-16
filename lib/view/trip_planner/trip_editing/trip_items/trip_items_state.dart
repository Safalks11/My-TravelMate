part of 'trip_items_bloc.dart';

@immutable
abstract class TripItemsState {}

class TripItemsInitial extends TripItemsState {}

class ItemsLoading extends TripItemsState {}

class ItemsLoaded extends TripItemsState {
  final List<ItemsModel> items;

  ItemsLoaded(this.items);
}

class ItemsError extends TripItemsState {
  final String message;

  ItemsError(this.message);
}
