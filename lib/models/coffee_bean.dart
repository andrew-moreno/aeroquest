const String tableCoffeeBeans = "coffeeBeans";

class CoffeeBeanFields {
  static final List<String> values = [
    id,
    beanName,
    description,
    associatedSettingsCount,
  ];

  static const String id = "_id";
  static const String beanName = "beanName";
  static const String description = "description";
  static const String associatedSettingsCount = "associatedSettingsCount";
}

class CoffeeBean {
  final int? id;
  String beanName;
  String? description;

  /// Recipe settings that use this coffee bean
  int associatedSettingsCount;

  CoffeeBean(
      {this.id,
      required this.beanName,
      this.description,
      required this.associatedSettingsCount});

  /// Copies a CoffeeBean object
  ///
  /// The copied object will use any parameters passed into this method
  CoffeeBean copy({
    int? id,
    String? beanName,
    String? description,
    int? associatedSettingsCount,
  }) =>
      CoffeeBean(
        id: id ?? this.id,
        beanName: beanName ?? this.beanName,
        description: description ?? this.description,
        associatedSettingsCount:
            associatedSettingsCount ?? this.associatedSettingsCount,
      );

  /// Converts a CoffeeBean object to JSON format
  Map<String, Object?> toJson() => {
        CoffeeBeanFields.id: id,
        CoffeeBeanFields.beanName: beanName,
        CoffeeBeanFields.description: description,
        CoffeeBeanFields.associatedSettingsCount: associatedSettingsCount,
      };

  /// Converts a JSON coffee bean to a CoffeeBean object
  static CoffeeBean fromJson(Map<String, Object?> json) => CoffeeBean(
        id: json[CoffeeBeanFields.id] as int?,
        beanName: json[CoffeeBeanFields.beanName] as String,
        description: json[CoffeeBeanFields.description] as String?,
        associatedSettingsCount:
            json[CoffeeBeanFields.associatedSettingsCount] as int,
      );
}
