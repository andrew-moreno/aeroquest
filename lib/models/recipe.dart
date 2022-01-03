class Recipe {
  final String title;
  final String description;
  final List<Coffee> coffee;
  final PushPressure pushPressure;
  final BrewMethod brewMethod;
  final List<Notes> notes;

  const Recipe({
    required this.title,
    required this.description,
    required this.coffee,
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

class Coffee {
  final String name;
  final double grindSetting;
  final int coffeeAmount;
  final int waterAmount;
  final int waterTemp;
  final String brewTime;

  Coffee({
    required this.name,
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
