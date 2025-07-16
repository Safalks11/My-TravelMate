class NoteModel {
  final String id;
  final String title;
  final String description;
  final String date;

  NoteModel(
      {required this.id,
      required this.title,
      required this.description,
      required this.date});

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
        id: map['id'],
        title: map['title'],
        description: map['description'],
        date: map['date']);
  }
}
