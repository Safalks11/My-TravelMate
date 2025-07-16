import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:main_project/view/trip_planner/trip_editing/trip_notes/trip_notes_bloc.dart';

import '../../../../model/note_model.dart';
import '../../../../widgets/app_bar.dart';
import '../../../../widgets/section_title.dart';

class TripNotesScreen extends StatefulWidget {
  final String tripId;

  const TripNotesScreen({super.key, required this.tripId});

  @override
  State<TripNotesScreen> createState() => _TripNotesScreenState();
}

class _TripNotesScreenState extends State<TripNotesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TripNotesBloc>().add(LoadNotes(widget.tripId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showNoteBottomSheet(context),
        backgroundColor: Colors.blueAccent,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Add Note", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSectionTitle('Notes'),
            const SizedBox(height: 10),
            Expanded(
              child: BlocBuilder<TripNotesBloc, TripNotesState>(
                builder: (context, state) {
                  if (state is NotesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is NotesLoaded) {
                    if (state.notes.isEmpty) {
                      return const Center(
                        child: Text(
                          "No notes added yet!",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      );
                    }
                    return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: state.notes.length,
                      itemBuilder: (context, index) {
                        final note = state.notes[index];
                        return _buildNoteCard(context, note);
                      },
                    );
                  } else if (state is NotesError) {
                    return Center(
                        child: Text(state.message,
                            style: const TextStyle(color: Colors.red)));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteCard(BuildContext context, NoteModel note) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title & Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    note.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Text(
                  _formatDate(note.date),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Description
            Text(
              note.description,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blueAccent),
                  onPressed: () => _showNoteBottomSheet(context, note: note),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () => _showDeleteDialog(context, note),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

// Function to format date

  String _formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString); // Parse ISO format
      return DateFormat("dd/MM/yyyy")
          .format(date); // Convert to "day/month/year"
    } catch (e) {
      return "Invalid date";
    }
  }

  void _showDeleteDialog(BuildContext context, NoteModel note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          'Delete Note?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text('This note will be permanently deleted.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              context
                  .read<TripNotesBloc>()
                  .add(DeleteNote(widget.tripId, note.id));
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showNoteBottomSheet(BuildContext context, {NoteModel? note}) {
    final TextEditingController titleController =
        TextEditingController(text: note?.title ?? "");
    final TextEditingController contentController =
        TextEditingController(text: note?.description ?? "");

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                note == null ? "Add Note" : "Edit Note",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: "Title",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: contentController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Enter your trip note...",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ButtonStyle(
                      foregroundColor: WidgetStatePropertyAll(Colors.white),
                      backgroundColor: WidgetStatePropertyAll(Colors.green),
                    ),
                    onPressed: () {
                      if (titleController.text.isNotEmpty &&
                          contentController.text.isNotEmpty) {
                        if (note == null) {
                          context.read<TripNotesBloc>().add(
                                AddNote(
                                  widget.tripId,
                                  NoteModel(
                                    title: titleController.text,
                                    description: contentController.text,
                                    date: DateTime.now().toString(),
                                    id: '',
                                  ),
                                ),
                              );
                        } else {
                          context.read<TripNotesBloc>().add(
                                UpdateNote(
                                  widget.tripId,
                                  NoteModel(
                                    title: titleController.text,
                                    description: contentController.text,
                                    date: DateTime.now().toString(),
                                    id: note.id,
                                  ),
                                ),
                              );
                        }
                        Navigator.pop(context);
                      }
                    },
                    label: const Text("Save"),
                    icon: Icon(Icons.check_circle),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
