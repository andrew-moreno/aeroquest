const String tableCoffeeSettings = "coffeeSettings";

class CoffeeSettingsFields {
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
class CoffeeSettings {
  final int? id;
  int recipeEntryId;
  int beanId;
  double grindSetting;
  double coffeeAmount;
  int waterAmount;
  int waterTemp;
  int brewTime;
  String visibility;

  CoffeeSettings({
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

  CoffeeSettings copy({
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
      CoffeeSettings(
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
        CoffeeSettingsFields.id: id,
        CoffeeSettingsFields.recipeEntryId: recipeEntryId,
        CoffeeSettingsFields.beanId: beanId,
        CoffeeSettingsFields.grindSetting: grindSetting,
        CoffeeSettingsFields.coffeeAmount: coffeeAmount,
        CoffeeSettingsFields.waterAmount: waterAmount,
        CoffeeSettingsFields.waterTemp: waterTemp,
        CoffeeSettingsFields.brewTime: brewTime,
        CoffeeSettingsFields.visibility: visibility,
      };

  static CoffeeSettings fromJson(Map<String, Object?> json) => CoffeeSettings(
        id: json[CoffeeSettingsFields.id] as int?,
        recipeEntryId: json[CoffeeSettingsFields.recipeEntryId] as int,
        beanId: json[CoffeeSettingsFields.beanId] as int,
        waterAmount: json[CoffeeSettingsFields.waterAmount] as int,
        waterTemp: json[CoffeeSettingsFields.waterTemp] as int,
        brewTime: json[CoffeeSettingsFields.brewTime] as int,
        coffeeAmount: json[CoffeeSettingsFields.coffeeAmount] as double,
        grindSetting: json[CoffeeSettingsFields.grindSetting] as double,
        visibility: json[CoffeeSettingsFields.visibility] as String,
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
