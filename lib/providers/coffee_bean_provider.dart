import 'dart:developer';
import 'package:aeroquest/databases/coffee_beans_database.dart';
import 'package:flutter/material.dart';

import 'package:aeroquest/models/coffee_bean.dart';

class CoffeeBeanProvider extends ChangeNotifier {
  Future<void> addBean(String beanName, String? description) async {
    //TODO: prevent duplicate beans from being added
    final newCoffeeBean = CoffeeBean(
      beanName: beanName,
      description: description,
    );
    await CoffeeBeansDatabase.instance.create(newCoffeeBean);
    log("Beans added");
    notifyListeners();
  }

  Future<void> deleteBean(int id) async {
    await CoffeeBeansDatabase.instance.delete(id);
    log("beans removed with id: " + id.toString());
    notifyListeners();
  }

  Future<void> editBean(int id, String beanName, String? description) async {
    final coffeeBean = CoffeeBean(
      id: id,
      beanName: beanName,
      description: description,
    );
    await CoffeeBeansDatabase.instance.update(coffeeBean);

    log("beans updated with id: " + id.toString());
    notifyListeners();
  }
}
