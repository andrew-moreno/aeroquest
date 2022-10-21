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
  int associatedSettingsCount;

  CoffeeBean(
      {this.id,
      required this.beanName,
      this.description,
      required this.associatedSettingsCount});

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

  Map<String, Object?> toJson() => {
        CoffeeBeanFields.id: id,
        CoffeeBeanFields.beanName: beanName,
        CoffeeBeanFields.description: description,
        CoffeeBeanFields.associatedSettingsCount: associatedSettingsCount,
      };

  static CoffeeBean fromJson(Map<String, Object?> json) => CoffeeBean(
        id: json[CoffeeBeanFields.id] as int?,
        beanName: json[CoffeeBeanFields.beanName] as String,
        description: json[CoffeeBeanFields.description] as String?,
        associatedSettingsCount:
            json[CoffeeBeanFields.associatedSettingsCount] as int,
      );
}
