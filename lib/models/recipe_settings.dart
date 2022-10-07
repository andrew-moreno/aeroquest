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

// defines object for the settings for each bean
class RecipeSettings {
  final int? id;
  int recipeEntryId;
  int beanId;
  double grindSetting;
  double coffeeAmount;
  int waterAmount;
  int waterTemp;
  int brewTime;
  String visibility;

  RecipeSettings({
    this.id,
    required this.recipeEntryId,
    required this.beanId,
    required this.grindSetting,
    required this.coffeeAmount, // in grams
    required this.waterAmount, // in grams
    required this.waterTemp, // in celsius
    required this.brewTime, // in 10 second intervals
    required this.visibility,
  });

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

enum SettingVisibility { shown, hidden }
