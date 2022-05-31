class RecipeEntry {
  final int id;
  String title;
  String? description;
  List<CoffeeSettings> coffeeSettings;
  PushPressure pushPressure;
  BrewMethod brewMethod;
  List<Notes> notes;

  RecipeEntry({
    required this.id,
    required this.title,
    this.description,
    required this.coffeeSettings,
    required this.pushPressure,
    required this.brewMethod,
    required this.notes,
  });
}

enum PushPressure {
  light,
  moderate,
  heavy,
}

enum BrewMethod {
  regular,
  inverted,
}

// defines object for the settings for each bean
class CoffeeSettings {
  final int id;
  String beanName;
  double grindSetting;
  double coffeeAmount;
  int waterAmount;
  int waterTemp;
  int brewTime;
  SettingVisibility visibility;

  CoffeeSettings({
    required this.id,
    required this.beanName,
    required this.grindSetting,
    required this.coffeeAmount, // in grams
    required this.waterAmount, // in grams
    required this.waterTemp, // in celsius
    required this.brewTime, // in 10 second intervals
    required this.visibility,
  });
}

enum SettingVisibility { shown, hidden }

class Notes {
  final String time;
  final String text;

  Notes({
    required this.time,
    required this.text,
  });
}
