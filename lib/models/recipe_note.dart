const String tableRecipeNotes = "recipeNotes";

class RecipeNoteFields {
  static final List<String> values = [
    id,
    recipeEntryId,
    index,
    text,
  ];

  static const String id = "_id";
  static const String recipeEntryId = "recipeEntryId";
  static const String index = "noteIndex";
  static const String text = "text";
}

class RecipeNote {
  final int? id;

  /// Id of the recipe that this recipe note belongs to
  int recipeEntryId;

  int index;

  /// Text for the recipe note
  String text;

  RecipeNote({
    this.id,
    required this.recipeEntryId,
    required this.index,
    required this.text,
  });

  /// Copies a RecipeNote object
  ///
  /// The copied object will use any parameters passed into this method
  RecipeNote copy({
    int? id,
    int? recipeEntryId,
    int? index,
    String? text,
  }) =>
      RecipeNote(
        id: id ?? this.id,
        recipeEntryId: recipeEntryId ?? this.recipeEntryId,
        index: index ?? this.index,
        text: text ?? this.text,
      );

  /// Converts a RecipeNote object to JSON format
  Map<String, Object?> toJson() => {
        RecipeNoteFields.id: id,
        RecipeNoteFields.recipeEntryId: recipeEntryId,
        RecipeNoteFields.index: index,
        RecipeNoteFields.text: text,
      };

  /// Converts a JSON recipe note to a RecipeNote object
  static RecipeNote fromJson(Map<String, Object?> json) => RecipeNote(
        id: json[RecipeNoteFields.id] as int?,
        recipeEntryId: json[RecipeNoteFields.recipeEntryId] as int,
        index: json[RecipeNoteFields.index] as int,
        text: json[RecipeNoteFields.text] as String,
      );
}
