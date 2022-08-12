const String tableCoffeeBeans = "coffeeBeans";

class CoffeeBeanFields {
  static final List<String> values = [
    id,
    beanName,
    description,
  ];

  static const String id = "_id";
  static const String beanName = "beanName";
  static const String description = "description";
}

class CoffeeBean {
  final int? id;
  String beanName;
  String? description;

  CoffeeBean({
    this.id,
    required this.beanName,
    this.description,
  });

  CoffeeBean copy({int? id, String? beanName, String? description}) =>
      CoffeeBean(
        id: id ?? this.id,
        beanName: beanName ?? this.beanName,
        description: description ?? this.description,
      );

  Map<String, Object?> toJson() => {
        CoffeeBeanFields.id: id,
        CoffeeBeanFields.beanName: beanName,
        CoffeeBeanFields.description: description,
      };

  static CoffeeBean fromJson(Map<String, Object?> json) => CoffeeBean(
        id: json[CoffeeBeanFields.id] as int?,
        beanName: json[CoffeeBeanFields.beanName] as String,
        description: json[CoffeeBeanFields.description] as String?,
      );
}
