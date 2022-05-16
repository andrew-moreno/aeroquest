import 'dart:collection';
import 'dart:developer';
import 'package:flutter/material.dart';

import 'package:aeroquest/models/coffee_bean_entry.dart';

class BeansProvider extends ChangeNotifier {
  final List<CoffeeBeanEntry> _beans = [
    CoffeeBeanEntry(
        beanName: "JJBean Bros", description: "This is a light roasted coffee"),
    CoffeeBeanEntry(
        beanName: "Xmas Gift from Parentals",
        description:
            "This is a dark roasted coffee that is yum yum in my bum bum"),
    CoffeeBeanEntry(
        beanName: "More coffee woohoo",
        description: "Idk what to write here anymore"),
    CoffeeBeanEntry(beanName: "Omg theres more??"),
    CoffeeBeanEntry(beanName: "Hello", description: "There u suck"),
  ];

  UnmodifiableListView<CoffeeBeanEntry> get beans {
    return UnmodifiableListView(_beans);
  }

  void addBean(String beanName, String? description) {
    _beans.add(CoffeeBeanEntry(beanName: beanName, description: description));
    log("Beans added");
    notifyListeners();
  }

  void deleteBean(int index) {
    _beans.removeAt(index);
    log("beans removed at index: " + index.toString());
    notifyListeners();
  }

  void editBean(String beanName, String? description, int index) {
    _beans[index].beanName = beanName;
    _beans[index].description = description;
    notifyListeners();
  }
}
