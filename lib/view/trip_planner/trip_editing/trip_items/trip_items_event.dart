part of 'trip_items_bloc.dart';

@immutable
abstract class TripItemsEvent {}

class LoadItems extends TripItemsEvent {
  final String tripId;

  LoadItems(this.tripId);
}

class AddItem extends TripItemsEvent {
  final String tripId;
  final ItemsModel item;

  AddItem(this.tripId, this.item);
}

class UpdatePackedStatus extends TripItemsEvent {
  final String tripId;
  final String itemId;
  final bool packed;

  UpdatePackedStatus(this.tripId, this.itemId, this.packed);
}

class DeleteItem extends TripItemsEvent {
  final String tripId;
  final String itemId;

  DeleteItem(this.tripId, this.itemId);
}
