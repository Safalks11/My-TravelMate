part of 'trip_notes_bloc.dart';

@immutable
abstract class TripNotesState {}

final class TripNotesInitial extends TripNotesState {}

final class NotesLoading extends TripNotesState {}

final class NotesLoaded extends TripNotesState {
  final List<NoteModel> notes;
  NotesLoaded(this.notes);
}

final class NotesError extends TripNotesState {
  final String message;
  NotesError(this.message);
}
