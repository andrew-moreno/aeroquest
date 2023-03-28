const String tableRecipeVariables = "recipeVariables";

class RecipeVariablesFields {
  static final List<String> values = [
    id,
    recipeEntryId,
    beanId,
    grindSetting,
    coffeeAmount,
    waterAmount,
    waterTemp,
    brewTime,
    visibility,
  ];

  static const String id = "_id";
  static const String recipeEntryId = "recipeEntryId";
  static const String beanId = "beanId";
  static const String grindSetting = "grindSetting";
  static const String coffeeAmount = "coffeeAmount";
  static const String waterAmount = "waterAmount";
  static const String waterTemp = "waterTemp";
  static const String brewTime = "brewTime";
  static const String visibility = "visibility";
}

class RecipeVariables {
  final int? id;

  /// Id of the recipe that these recipe variables are associated with
  int recipeEntryId;

  /// Id of the coffee beans that are used in this recipe variable
  int beanId;

  /// Grind variable used for this recipe variable
  double grindSetting;

  /// Amount of coffee used for this recipe variable in grams
  double coffeeAmount;

  /// Amount of water used for this recipe variable in grams
  double waterAmount;

  /// Temperature of the water used for this recipe variable in celsius
  double waterTemp;

  /// Time used for brewing for this recipe variable in 10 second intervals
  int brewTime;

  /// Whether to display this recipe variable in the [Recipes] screen or not
  ///
  /// Valid entries for [visibility] are "shown" or "hidden", which get
  /// converted to enums using [stringToVariableVisibility] method
  String visibility;

  RecipeVariables({
    this.id,
    required this.recipeEntryId,
    required this.beanId,
    required this.grindSetting,
    required this.coffeeAmount,
    required this.waterAmount,
    required this.waterTemp,
    required this.brewTime,
    required this.visibility,
  });

  /// Copies a RecipeVariables object
  ///
  /// The copied object will use any parameters passed into this method
  RecipeVariables copy({
    int? id,
    int? recipeEntryId,
    int? beanId,
    double? grindSetting,
    double? coffeeAmount,
    double? waterAmount,
    double? waterTemp,
    int? brewTime,
    String? visibility,
  }) =>
      RecipeVariables(
        id: id ?? this.id,
        recipeEntryId: recipeEntryId ?? this.recipeEntryId,
        beanId: beanId ?? this.beanId,
        grindSetting: grindSetting ?? this.grindSetting,
        coffeeAmount: coffeeAmount ?? this.coffeeAmount,
        waterAmount: waterAmount ?? this.waterAmount,
        waterTemp: waterTemp ?? this.waterTemp,
        brewTime: brewTime ?? this.brewTime,
        visibility: visibility ?? this.visibility,
      );

  /// Converts a CoffeeBean object to JSON format
  Map<String, Object?> toJson() => {
        RecipeVariablesFields.id: id,
        RecipeVariablesFields.recipeEntryId: recipeEntryId,
        RecipeVariablesFields.beanId: beanId,
        RecipeVariablesFields.grindSetting: grindSetting,
        RecipeVariablesFields.coffeeAmount: coffeeAmount,
        RecipeVariablesFields.waterAmount: waterAmount,
        RecipeVariablesFields.waterTemp: waterTemp,
        RecipeVariablesFields.brewTime: brewTime,
        RecipeVariablesFields.visibility: visibility,
      };

  /// Converts a JSON recipe variable to a RecipeVariables object
  static RecipeVariables fromJson(Map<String, Object?> json) => RecipeVariables(
        id: json[RecipeVariablesFields.id] as int?,
        recipeEntryId: json[RecipeVariablesFields.recipeEntryId] as int,
        beanId: json[RecipeVariablesFields.beanId] as int,
        waterAmount: json[RecipeVariablesFields.waterAmount] as double,
        waterTemp: json[RecipeVariablesFields.waterTemp] as double,
        brewTime: json[RecipeVariablesFields.brewTime] as int,
        coffeeAmount: json[RecipeVariablesFields.coffeeAmount] as double,
        grindSetting: json[RecipeVariablesFields.grindSetting] as double,
        visibility: json[RecipeVariablesFields.visibility] as String,
      );

  /// Converts the string representation of [visibility] to an enum
  ///
  /// Returns either [VariablesVisibility.shown] or [VariablesVisibility.hidden]
  ///
  /// Throws an exception if a string is passed that isn't "shown" or "hidden"
  static VariablesVisibility stringToVariablesVisibility(String action) {
    switch (action) {
      case "shown":
        return VariablesVisibility.shown;
      case "hidden":
        return VariablesVisibility.hidden;

      default:
        throw Exception("VariablesVisibility action name not found ");
    }
  }
}

/// Enum for describing recipe variable visibility
enum VariablesVisibility { shown, hidden }
