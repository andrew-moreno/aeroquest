class RecipeEntry {
  int id;
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
  final String beanName;
  final double grindSetting;
  final int coffeeAmount;
  final int waterAmount;
  final int waterTemp;
  final String brewTime;
  final bool isHidden;

  CoffeeSettings({
    required this.beanName,
    required this.grindSetting,
    required this.coffeeAmount,
    required this.waterAmount,
    required this.waterTemp,
    required this.brewTime,
    required this.isHidden,
  });
}

class Notes {
  final String time;
  final String text;

  Notes({
    required this.time,
    required this.text,
  });
}
