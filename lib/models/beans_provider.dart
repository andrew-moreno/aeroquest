import 'dart:collection';

import 'package:aeroquest/models/coffee_bean_entry.dart';
import 'package:flutter/material.dart';

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
    print("beans added");
    notifyListeners();
  }

  void deleteBean(int index) {
    print("index: " + index.toString());
    _beans.removeAt(index);
    notifyListeners();
  }

  void editBean(String beanName, String? description, int index) {
    _beans[index].beanName = beanName;
    _beans[index].description = description;
  }
}
