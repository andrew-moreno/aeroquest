const String tableRecipes = "recipes";

class RecipeFields {
  static final List<String> values = [
    id,
    title,
    description,
    pushPressure,
    brewMethod,
  ];

  static const String id = "_id";
  static const String title = "title";
  static const String description = "description";
  static const String pushPressure = "pushPressure";
  static const String brewMethod = "brewMethod";
}

class Recipe {
  final int? id;
  String title;
  String? description;
  String pushPressure;
  String brewMethod;

  Recipe({
    this.id,
    required this.title,
    this.description,
    required this.pushPressure,
    required this.brewMethod,
  });

  Recipe copy({
    int? id,
    String? title,
    String? description,
    String? pushPressure,
    String? brewMethod,
  }) =>
      Recipe(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        pushPressure: pushPressure ?? this.pushPressure,
        brewMethod: brewMethod ?? this.brewMethod,
      );

  Map<String, Object?> toJson() => {
        RecipeFields.id: id,
        RecipeFields.title: title,
        RecipeFields.description: description,
        RecipeFields.pushPressure: pushPressure,
        RecipeFields.brewMethod: brewMethod,
      };

  static Recipe fromJson(Map<String, Object?> json) => Recipe(
        id: json[RecipeFields.id] as int?,
        title: json[RecipeFields.title] as String,
        description: json[RecipeFields.description] as String?,
        pushPressure: json[RecipeFields.pushPressure] as String,
        brewMethod: json[RecipeFields.brewMethod] as String,
      );

  static PushPressure stringToPushPressure(String action) {
    switch (action) {
      case "light":
        return PushPressure.light;
      case "moderate":
        return PushPressure.moderate;
      case "heavy":
        return PushPressure.heavy;

      default:
        throw Exception("PushPressure action $action not found");
    }
  }

  static BrewMethod stringToBrewMethod(String action) {
    switch (action) {
      case "regular":
        return BrewMethod.regular;
      case "inverted":
        return BrewMethod.inverted;

      default:
        throw Exception("BrewMethod action $action not found");
    }
  }
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
