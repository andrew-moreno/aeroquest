import 'dart:collection';
import 'dart:developer';
import 'package:aeroquest/databases/coffee_beans_database.dart';
import 'package:aeroquest/databases/recipe_settings_database.dart';
import 'package:flutter/material.dart';

import 'package:aeroquest/models/coffee_bean.dart';

class CoffeeBeanProvider extends ChangeNotifier {
  late Map<int, CoffeeBean> _coffeeBeans;

  UnmodifiableMapView<int, CoffeeBean> get coffeeBeans {
    return UnmodifiableMapView(_coffeeBeans);
  }

  Future<void> cacheCoffeeBeans() async {
    _coffeeBeans = await CoffeeBeansDatabase.instance.readAllCoffeeBeans();
  }

  Future<CoffeeBean> addBean(String beanName, String? description) async {
    final newCoffeeBean = await CoffeeBeansDatabase.instance.create(
      CoffeeBean(
        beanName: beanName,
        description: description,
        associatedSettingsCount: 0,
      ),
    );
    _coffeeBeans.addAll({newCoffeeBean.id!: newCoffeeBean});
    notifyListeners();
    return newCoffeeBean;
  }

  Future<void> deleteBean(
      {required int id, deleteAssociatedSettings = false}) async {
    if (deleteAssociatedSettings) {
      await RecipeSettingsDatabase.instance.deleteSettingsOfBeanId(id);
    }
    _coffeeBeans.remove(id);
    await CoffeeBeansDatabase.instance.delete(id);
    log("beans removed with id: " + id.toString());
    notifyListeners();
  }

  Future<void> editBean(
    int id,
    String beanName,
    String? description,
    int associatedSettingsCount,
  ) async {
    final coffeeBean = CoffeeBean(
      id: id,
      beanName: beanName,
      description: description,
      associatedSettingsCount: associatedSettingsCount,
    );
    _coffeeBeans[id]!.beanName = beanName;
    _coffeeBeans[id]?.description = description;
    _coffeeBeans[id]!.associatedSettingsCount = associatedSettingsCount;
    await CoffeeBeansDatabase.instance.update(coffeeBean);
    log("beans updated with id: " + id.toString());
    notifyListeners();
  }
}
