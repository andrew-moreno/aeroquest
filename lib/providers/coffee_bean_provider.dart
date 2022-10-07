import 'dart:collection';
import 'dart:developer';
import 'package:aeroquest/databases/coffee_beans_database.dart';
import 'package:flutter/material.dart';

import 'package:aeroquest/models/coffee_bean.dart';

class CoffeeBeanProvider extends ChangeNotifier {
  late List<CoffeeBean> _coffeeBeansList;

  UnmodifiableListView<CoffeeBean> get coffeeBeansList {
    return UnmodifiableListView(_coffeeBeansList);
  }

  Future<void> cacheBeans() async {
    _coffeeBeansList = await CoffeeBeansDatabase.instance.readAllCoffeeBeans();
  }

  Future<void> addBean(String beanName, String? description) async {
    //TODO: prevent duplicate beans from being added
    final newCoffeeBean = CoffeeBean(
      beanName: beanName,
      description: description,
    );
    _coffeeBeansList
        .add(await CoffeeBeansDatabase.instance.create(newCoffeeBean));
    notifyListeners();
    log("Beans added");
  }

  Future<void> deleteBean(int id) async {
    _coffeeBeansList.removeWhere((coffeeBean) => coffeeBean.id == id);
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
    _coffeeBeansList.firstWhere((coffeeBean) => coffeeBean.id == id).beanName =
        beanName;
    _coffeeBeansList
        .firstWhere((coffeeBean) => coffeeBean.id == id)
        .description = description;
    await CoffeeBeansDatabase.instance.update(coffeeBean);
    log("beans updated with id: " + id.toString());
    notifyListeners();
  }
}
