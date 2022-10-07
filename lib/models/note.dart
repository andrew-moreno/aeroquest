const String tableNotes = "notes";

class NoteFields {
  static final List<String> values = [
    id,
    recipeEntryId,
    time,
    text,
  ];

  static const String id = "_id";
  static const String recipeEntryId = "recipeEntryId";
  static const String time = "time";
  static const String text = "text";
}

class Note {
  final int? id;
  int recipeEntryId;
  int time;
  String text;

  Note({
    this.id,
    required this.recipeEntryId,
    required this.time,
    required this.text,
  });

  Note copy({
    int? id,
    int? recipeEntryId,
    int? time,
    String? text,
  }) =>
      Note(
        id: id ?? this.id,
        recipeEntryId: recipeEntryId ?? this.recipeEntryId,
        time: time ?? this.time,
        text: text ?? this.text,
      );

  Map<String, Object?> toJson() => {
        NoteFields.id: id,
        NoteFields.recipeEntryId: recipeEntryId,
        NoteFields.time: time,
        NoteFields.text: text,
      };

  static Note fromJson(Map<String, Object?> json) => Note(
        id: json[NoteFields.id] as int?,
        recipeEntryId: json[NoteFields.recipeEntryId] as int,
        time: json[NoteFields.time] as int,
        text: json[NoteFields.text] as String,
      );
}
