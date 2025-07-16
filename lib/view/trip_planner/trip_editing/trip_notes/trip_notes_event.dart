part of 'trip_notes_bloc.dart';

@immutable
abstract class TripNotesEvent {}

class LoadNotes extends TripNotesEvent {
  final String tripId;
  LoadNotes(this.tripId);
}

class AddNote extends TripNotesEvent {
  final String tripId;
  final NoteModel note;
  AddNote(this.tripId, this.note);
}

class UpdateNote extends TripNotesEvent {
  final String tripId;
  final NoteModel note;
  UpdateNote(this.tripId, this.note);
}

class DeleteNote extends TripNotesEvent {
  final String tripId;
  final String noteId;
  DeleteNote(this.tripId, this.noteId);
}
