import 'dart:collection';
import 'dart:developer';
import 'package:aeroquest/databases/coffee_beans_database.dart';
import 'package:aeroquest/databases/recipe_settings_database.dart';
import 'package:flutter/material.dart';

import 'package:aeroquest/models/coffee_bean.dart';

class CoffeeBeanProvider extends ChangeNotifier {
  late List<CoffeeBean> _coffeeBeans;

  UnmodifiableListView<CoffeeBean> get coffeeBeans {
    return UnmodifiableListView(_coffeeBeans);
  }

  Future<void> cacheCoffeeBeans() async {
    _coffeeBeans = await CoffeeBeansDatabase.instance.readAllCoffeeBeans();
  }

  Future<void> addBean(String beanName, String? description) async {
    final newCoffeeBean = await CoffeeBeansDatabase.instance.create(
      CoffeeBean(
        beanName: beanName,
        description: description,
        associatedSettingsCount: 0,
      ),
    );
    _coffeeBeans.add(newCoffeeBean);
    notifyListeners();
  }

  Future<void> deleteBean(
      {required int id, deleteAssociatedSettings = false}) async {
    if (deleteAssociatedSettings) {
      await RecipeSettingsDatabase.instance.deleteSettingsOfBeanId(id);
    }
    _coffeeBeans.removeWhere((coffeeBean) => coffeeBean.id == id);
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
    _coffeeBeans.firstWhere((coffeeBean) => coffeeBean.id == id).beanName =
        beanName;
    _coffeeBeans.firstWhere((coffeeBean) => coffeeBean.id == id).description =
        description;
    _coffeeBeans
        .firstWhere((coffeeBean) => coffeeBean.id == id)
        .associatedSettingsCount = associatedSettingsCount;
    await CoffeeBeansDatabase.instance.update(coffeeBean);
    log("beans updated with id: " + id.toString());
    notifyListeners();
  }
}
