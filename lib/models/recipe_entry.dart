class RecipeEntry {
  final String title;
  final String description;
  final List<CoffeeSetting> coffeeSetting;
  final PushPressure pushPressure;
  final BrewMethod brewMethod;
  final List<Notes> notes;

  const RecipeEntry({
    required this.title,
    required this.description,
    required this.coffeeSetting,
    required this.pushPressure,
    required this.brewMethod,
    required this.notes,
  });
}

enum PushPressure {
  weak,
  medium,
  strong,
}

enum BrewMethod {
  regular,
  inverted,
}

// defines object for the settings for each bean
class CoffeeSetting {
  final String beanName;
  final double grindSetting;
  final int coffeeAmount;
  final int waterAmount;
  final int waterTemp;
  final String brewTime;

  CoffeeSetting({
    required this.beanName,
    required this.grindSetting,
    required this.coffeeAmount,
    required this.waterAmount,
    required this.waterTemp,
    required this.brewTime,
  });
}

class Notes {
  final String time;
  final String note;

  Notes({
    required this.time,
    required this.note,
  });
}
