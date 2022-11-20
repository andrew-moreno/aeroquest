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

  /// Id of the recipe that this note belongs to
  int recipeEntryId;

  /// The time at which this note should be executed
  int time;

  /// Text for the note
  String text;

  Note({
    this.id,

    /// Id of the recipe that this note is associated with
    required this.recipeEntryId,

    /// Time at which this note is executed in 10 second intervals
    required this.time,

    /// Text used for this note
    required this.text,
  });

  /// Copies a Note object
  ///
  /// The copied object will use any parameters passed into this method
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

  /// Converts a Note object to JSON format
  Map<String, Object?> toJson() => {
        NoteFields.id: id,
        NoteFields.recipeEntryId: recipeEntryId,
        NoteFields.time: time,
        NoteFields.text: text,
      };

  /// Converts a JSON note to a Note object
  static Note fromJson(Map<String, Object?> json) => Note(
        id: json[NoteFields.id] as int?,
        recipeEntryId: json[NoteFields.recipeEntryId] as int,
        time: json[NoteFields.time] as int,
        text: json[NoteFields.text] as String,
      );
}
