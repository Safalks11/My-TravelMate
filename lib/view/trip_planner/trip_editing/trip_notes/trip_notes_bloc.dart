import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../controller/firebase_helper/firebase_helper.dart';
import '../../../../model/note_model.dart';

part 'trip_notes_event.dart';
part 'trip_notes_state.dart';

class TripNotesBloc extends Bloc<TripNotesEvent, TripNotesState> {
  final FirebaseHelper _firebaseHelper = FirebaseHelper();

  TripNotesBloc() : super(TripNotesInitial()) {
    on<LoadNotes>(_onLoadNotes);
    on<AddNote>(_onAddNote);
    on<UpdateNote>(_onUpdateNote);
    on<DeleteNote>(_onDeleteNote);
  }

  Future<void> _onLoadNotes(
      LoadNotes event, Emitter<TripNotesState> emit) async {
    emit(NotesLoading());
    try {
      final notes = await _firebaseHelper.getNotes(event.tripId);
      emit(NotesLoaded(notes)); // ✅ Ensure new state is emitted
    } catch (e, st) {
      print('$e \n $st');
      emit(NotesError("Failed to load notes: $e"));
    }
  }

  Future<void> _onAddNote(AddNote event, Emitter<TripNotesState> emit) async {
    try {
      await _firebaseHelper.addNote(event.tripId, event.note);
      final notes =
          await _firebaseHelper.getNotes(event.tripId); // ✅ Fetch updated notes
      emit(NotesLoaded(notes)); // ✅ Immediately update UI
    } catch (e, st) {
      print('$e \n $st');
      emit(NotesError("Failed to add note: $e"));
    }
  }

  Future<void> _onUpdateNote(
      UpdateNote event, Emitter<TripNotesState> emit) async {
    try {
      await _firebaseHelper.updateNote(event.tripId, event.note);
      final notes = await _firebaseHelper.getNotes(event.tripId);
      emit(NotesLoaded(notes)); // ✅ Update UI with latest notes
    } catch (e) {
      emit(NotesError("Failed to update note: $e"));
    }
  }

  Future<void> _onDeleteNote(
      DeleteNote event, Emitter<TripNotesState> emit) async {
    try {
      await _firebaseHelper.deleteNote(event.tripId, event.noteId);
      final notes = await _firebaseHelper.getNotes(event.tripId);
      emit(NotesLoaded(notes)); // ✅ Update UI after deletion
    } catch (e) {
      emit(NotesError("Failed to delete note: $e"));
    }
  }
}
