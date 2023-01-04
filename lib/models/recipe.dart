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

  /// Title of this recipe
  String title;

  /// Description of this recipe
  ///
  /// If null, no description will be displayed
  String? description;

  /// Amount of pressure applied to the AeroPress when extracting coffee
  ///
  /// Valid entries for [pushPressure] are "light" and "heavy", which get
  /// converted to enums using [stringToPushPressure] method
  String pushPressure;

  /// Type of brew method to use when brewing coffee
  ///
  /// Valid entries for [brewMethod] are "regular" and "inverted", which get
  /// converted to enums using [stringToBrewMethod] method
  String brewMethod;

  Recipe({
    this.id,
    required this.title,
    this.description,
    required this.pushPressure,
    required this.brewMethod,
  });

  /// Copies a Recipe object
  ///
  /// The copied object will use any parameters passed into this method
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

  /// Converts a Recipe object to JSON format
  Map<String, Object?> toJson() => {
        RecipeFields.id: id,
        RecipeFields.title: title,
        RecipeFields.description: description,
        RecipeFields.pushPressure: pushPressure,
        RecipeFields.brewMethod: brewMethod,
      };

  /// Converts a JSON recipe to a Recipe object
  static Recipe fromJson(Map<String, Object?> json) => Recipe(
        id: json[RecipeFields.id] as int?,
        title: json[RecipeFields.title] as String,
        description: json[RecipeFields.description] as String?,
        pushPressure: json[RecipeFields.pushPressure] as String,
        brewMethod: json[RecipeFields.brewMethod] as String,
      );

  /// Converts the string representation of [pushPressure] to an enum
  ///
  /// Returns either [PushPressure.light] or [PushPressure.heavy]
  ///
  /// Throws an exception if a string is passed that isn't "light" or "heavy"
  static PushPressure stringToPushPressure(String action) {
    switch (action) {
      case "light":
        return PushPressure.light;

      case "heavy":
        return PushPressure.heavy;

      default:
        throw Exception("PushPressure action $action not found");
    }
  }

  /// Converts a string representation of [brewMethod] to an enum
  ///
  /// Returns either [BrewMethod.regular] or [BrewMethod.inverted]
  ///
  /// Throws an exception if a string is passed that isn't "regular"
  /// or "inverted"
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

/// Enum for describing the recipes push pressure
///
/// Possible values are [light] and [heavy]
enum PushPressure {
  light,
  heavy,
}

/// Enum for describing the recipes brew method
///
/// Possible values are [regular] and [inverted]
enum BrewMethod {
  regular,
  inverted,
}
