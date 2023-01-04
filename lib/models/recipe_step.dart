const String tableRecipeSteps = "recipeSteps";

class RecipeStepFields {
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

class RecipeStep {
  final int? id;

  /// Id of the recipe that this recipe step belongs to
  int recipeEntryId;

  /// The time at which this recipe step should be executed
  int time;

  /// Text for the recipe step
  String text;

  RecipeStep({
    this.id,

    /// Id of the recipe that this recipe step is associated with
    required this.recipeEntryId,

    /// Time at which this recipe step is executed in 10 second intervals
    required this.time,

    /// Text used for this recipe step
    required this.text,
  });

  /// Copies a RecipeStep object
  ///
  /// The copied object will use any parameters passed into this method
  RecipeStep copy({
    int? id,
    int? recipeEntryId,
    int? time,
    String? text,
  }) =>
      RecipeStep(
        id: id ?? this.id,
        recipeEntryId: recipeEntryId ?? this.recipeEntryId,
        time: time ?? this.time,
        text: text ?? this.text,
      );

  /// Converts a RecipeStep object to JSON format
  Map<String, Object?> toJson() => {
        RecipeStepFields.id: id,
        RecipeStepFields.recipeEntryId: recipeEntryId,
        RecipeStepFields.time: time,
        RecipeStepFields.text: text,
      };

  /// Converts a JSON recipe step to a RecipeStep object
  static RecipeStep fromJson(Map<String, Object?> json) => RecipeStep(
        id: json[RecipeStepFields.id] as int?,
        recipeEntryId: json[RecipeStepFields.recipeEntryId] as int,
        time: json[RecipeStepFields.time] as int,
        text: json[RecipeStepFields.text] as String,
      );
}
