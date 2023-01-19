const String tableRecipeNotes = "recipeNotes";

class RecipeNoteFields {
  static final List<String> values = [
    id,
    recipeEntryId,
    text,
  ];

  static const String id = "_id";
  static const String recipeEntryId = "recipeEntryId";
  static const String text = "text";
}

class RecipeNote {
  final int? id;

  /// Id of the recipe that this recipe note belongs to
  int recipeEntryId;

  /// Text for the recipe note
  String text;

  RecipeNote({
    this.id,

    /// Id of the recipe that this recipe note is associated with
    required this.recipeEntryId,

    /// Text used for this recipe note
    required this.text,
  });

  /// Copies a RecipeNote object
  ///
  /// The copied object will use any parameters passed into this method
  RecipeNote copy({
    int? id,
    int? recipeEntryId,
    String? text,
  }) =>
      RecipeNote(
        id: id ?? this.id,
        recipeEntryId: recipeEntryId ?? this.recipeEntryId,
        text: text ?? this.text,
      );

  /// Converts a RecipeNote object to JSON format
  Map<String, Object?> toJson() => {
        RecipeNoteFields.id: id,
        RecipeNoteFields.recipeEntryId: recipeEntryId,
        RecipeNoteFields.text: text,
      };

  /// Converts a JSON recipe note to a RecipeNote object
  static RecipeNote fromJson(Map<String, Object?> json) => RecipeNote(
        id: json[RecipeNoteFields.id] as int?,
        recipeEntryId: json[RecipeNoteFields.recipeEntryId] as int,
        text: json[RecipeNoteFields.text] as String,
      );
}
