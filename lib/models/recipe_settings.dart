const String tableRecipeSettings = "recipeSettings";

class RecipeSettingsFields {
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

class RecipeSettings {
  final int? id;

  /// Id of the recipe that these recipe settings are associated with
  int recipeEntryId;

  /// Id of the coffee beans that are used in this recipe setting
  int beanId;

  /// Grind setting used for this recipe setting
  double grindSetting;

  /// Amount of coffee used for this recipe setting in grams
  double coffeeAmount;

  /// Amount of water used for this recipe setting in grams
  int waterAmount;

  /// Temperature of the water used for this recipe setting in celsius
  int waterTemp;

  /// Time used for brewing for this recipe setting in 10 second intervals
  int brewTime;

  /// Whether to display this recipe setting in the [Recipes] screen or not
  ///
  /// Valid entries for [visibility] are "shown" or "hidden", which get
  /// converted to enums using [stringToSettingVisibility] method
  String visibility;

  RecipeSettings({
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

  /// Copies a RecipeSettings object
  ///
  /// The copied object will use any parameters passed into this method
  RecipeSettings copy({
    int? id,
    int? recipeEntryId,
    int? beanId,
    double? grindSetting,
    double? coffeeAmount,
    int? waterAmount,
    int? waterTemp,
    int? brewTime,
    String? visibility,
  }) =>
      RecipeSettings(
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
        RecipeSettingsFields.id: id,
        RecipeSettingsFields.recipeEntryId: recipeEntryId,
        RecipeSettingsFields.beanId: beanId,
        RecipeSettingsFields.grindSetting: grindSetting,
        RecipeSettingsFields.coffeeAmount: coffeeAmount,
        RecipeSettingsFields.waterAmount: waterAmount,
        RecipeSettingsFields.waterTemp: waterTemp,
        RecipeSettingsFields.brewTime: brewTime,
        RecipeSettingsFields.visibility: visibility,
      };

  /// Converts a JSON recipe setting to a RecipeSetting object
  static RecipeSettings fromJson(Map<String, Object?> json) => RecipeSettings(
        id: json[RecipeSettingsFields.id] as int?,
        recipeEntryId: json[RecipeSettingsFields.recipeEntryId] as int,
        beanId: json[RecipeSettingsFields.beanId] as int,
        waterAmount: json[RecipeSettingsFields.waterAmount] as int,
        waterTemp: json[RecipeSettingsFields.waterTemp] as int,
        brewTime: json[RecipeSettingsFields.brewTime] as int,
        coffeeAmount: json[RecipeSettingsFields.coffeeAmount] as double,
        grindSetting: json[RecipeSettingsFields.grindSetting] as double,
        visibility: json[RecipeSettingsFields.visibility] as String,
      );

  /// Converts the string representation of [visibility] to an enum
  ///
  /// Returns either [SettingVisibility.shown] or [SettingVisibility.hidden]
  ///
  /// Throws an exception if a string is passed that isn't "shown" or "hidden"
  static SettingVisibility stringToSettingVisibility(String action) {
    switch (action) {
      case "shown":
        return SettingVisibility.shown;
      case "hidden":
        return SettingVisibility.hidden;

      default:
        throw Exception("SettingVisibility action name not found ");
    }
  }
}

/// Enum for describing recipe setting visibility
enum SettingVisibility { shown, hidden }
