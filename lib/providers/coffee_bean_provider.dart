import 'dart:collection';
import 'dart:developer';

import 'package:aeroquest/databases/coffee_beans_database.dart';
import 'package:aeroquest/databases/recipe_variables_database.dart';
import 'package:aeroquest/models/coffee_bean.dart';

import 'package:flutter/material.dart';

class CoffeeBeanProvider extends ChangeNotifier {
  /// Holds up to date information on the coffee beans in the coffee beans
  /// database mapped by id
  late Map<int, CoffeeBean> _coffeeBeans;

  /// Returns an unmodifiable version of [_coffeeBeans]
  UnmodifiableMapView<int, CoffeeBean> get coffeeBeans {
    return UnmodifiableMapView(_coffeeBeans);
  }

  /// Populates [_coffeeBeans] with data from the database
  Future<void> cacheCoffeeBeans() async {
    _coffeeBeans = await CoffeeBeansDatabase.instance.readAllCoffeeBeans();
  }

  /// Adds a coffee bean to the database and [_coffeeBeans]
  ///
  /// Returns the added coffee bean
  Future<CoffeeBean> addBean(String beanName, String? description) async {
    final newCoffeeBean = await CoffeeBeansDatabase.instance.create(
      CoffeeBean(
        beanName: beanName,
        description: description,
        associatedVariablesCount: 0,
      ),
    );
    _coffeeBeans.addAll({newCoffeeBean.id!: newCoffeeBean});
    notifyListeners();
    log("Coffee beans added with id: " + newCoffeeBean.id.toString());
    return newCoffeeBean;
  }

  /// Deletes a bean from the database and [_coffeeBeans]
  ///
  /// If [deleteAssociatedVariables] is true, will also delete recipe variables
  /// that use this coffee bean
  Future<void> deleteBean({
    required int id,
    deleteAssociatedVariables = false,
  }) async {
    if (deleteAssociatedVariables) {
      await RecipeVariablesDatabase.instance.deleteVariablesOfBeanId(id);
    }
    _coffeeBeans.remove(id);
    await CoffeeBeansDatabase.instance.delete(id);

    log("Coffee beans removed with id: " + id.toString());
    if (deleteAssociatedVariables) {
      log("Associated recipe variables also deleted");
    }
    notifyListeners();
  }

  /// Updates a coffee bean
  Future<void> editBean(
    int id,
    String beanName,
    String? description,
    int associatedVariablesCount,
  ) async {
    final coffeeBean = CoffeeBean(
      id: id,
      beanName: beanName,
      description: description,
      associatedVariablesCount: associatedVariablesCount,
    );
    _coffeeBeans[id]!.beanName = beanName;
    _coffeeBeans[id]?.description = description;
    _coffeeBeans[id]!.associatedVariablesCount = associatedVariablesCount;
    await CoffeeBeansDatabase.instance.update(coffeeBean);
    log("beans updated with id: " + id.toString());
    notifyListeners();
  }
}
