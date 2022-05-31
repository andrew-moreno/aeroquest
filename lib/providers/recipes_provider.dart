import 'dart:collection';
import 'dart:developer';
import 'package:flutter/material.dart';

import 'package:aeroquest/widgets/recipe_settings/widgets/settings_value.dart';
import 'package:aeroquest/models/recipe_entry.dart';

class RecipesProvider extends ChangeNotifier {
  final List<RecipeEntry> _recipes = [
    RecipeEntry(
      id: 1,
      title: "The Hoffman Special",
      description: "Hot cup that serves one",
      coffeeSettings: [
        CoffeeSettings(
          beanName: "JJBean Bros",
          grindSetting: 17,
          coffeeAmount: 11,
          waterAmount: 200,
          waterTemp: 100,
          brewTime: 15,
          isHidden: true,
        ),
        CoffeeSettings(
          beanName: "JJBean Bros",
          grindSetting: 17,
          coffeeAmount: 12,
          waterAmount: 200,
          waterTemp: 86,
          brewTime: 15,
          isHidden: false,
        ),
      ],
      pushPressure: PushPressure.light,
      brewMethod: BrewMethod.regular,
      notes: [
        Notes(time: "2:30", text: "Lightly swirl to bring grounds to bottom"),
        Notes(time: "2:30", text: "Lightly swirl to bring grounds to bottom"),
        Notes(time: "2:30", text: "Lightly swirl to bring grounds to bottom"),
        Notes(time: "2:30", text: "Lightly swirl to bring grounds to bottom"),
        Notes(time: "2:30", text: "Lightly swirl to bring grounds to bottom"),
        Notes(time: "2:30", text: "Lightly swirl to bring grounds to bottom"),
        Notes(time: "2:30", text: "Lightly swirl to bring grounds to bottom"),
        Notes(time: "2:30", text: "Lightly swirl to bring grounds to bottom"),
        Notes(time: "2:30", text: "Lightly swirl to bring grounds to bottom"),
        Notes(time: "2:30", text: "Lightly swirl to bring grounds to bottom"),
      ],
    ),
    RecipeEntry(
      id: 2,
      title: "StrongBoi 3000 That Is Just RichBoi",
      description:
          "Rich and full-bodied hot cup that serves one and is yum yum in my tum tum and im making this super long on purpose omg this is a long description",
      coffeeSettings: [
        CoffeeSettings(
          beanName: "JJBean",
          grindSetting: 16.5,
          coffeeAmount: 18,
          waterAmount: 260,
          waterTemp: 95,
          brewTime: 51,
          isHidden: true,
        )
      ],
      pushPressure: PushPressure.light,
      brewMethod: BrewMethod.inverted,
      notes: [
        Notes(
            time: "0:00",
            text: "Stir back and forth to wet all grounds in Aeropress"),
        Notes(
            time: "2:00", text: "Be like omg this about to be yum can't wait!"),
      ],
    ),
    RecipeEntry(
      id: 3,
      title: "The Hoffman Special",
      description: "Hot cup that serves one",
      coffeeSettings: [
        CoffeeSettings(
          beanName: "JJBean",
          grindSetting: 17,
          coffeeAmount: 11,
          waterAmount: 200,
          waterTemp: 100,
          brewTime: 15,
          isHidden: true,
        ),
        CoffeeSettings(
          beanName: "Dark Xmas Gift from Parentals",
          grindSetting: 17,
          coffeeAmount: 12,
          waterAmount: 200,
          waterTemp: 86,
          brewTime: 15,
          isHidden: true,
        ),
      ],
      pushPressure: PushPressure.light,
      brewMethod: BrewMethod.regular,
      notes: [
        Notes(time: "2:30", text: "Lightly swirl to bring grounds to bottom"),
      ],
    ),
    RecipeEntry(
      id: 4,
      title: "The Hoffman Special",
      description: "Hot cup that serves one",
      coffeeSettings: [
        CoffeeSettings(
          beanName: "JJBean",
          grindSetting: 17,
          coffeeAmount: 11,
          waterAmount: 200,
          waterTemp: 100,
          brewTime: 15,
          isHidden: true,
        ),
        CoffeeSettings(
          beanName:
              "Dark Xmas Gift from Parentals that is super yummy and this is gonna be long also wowee woo wawa omg omg omg i like coffee",
          grindSetting: 17,
          coffeeAmount: 12,
          waterAmount: 200,
          waterTemp: 86,
          brewTime: 15,
          isHidden: true,
        ),
      ],
      pushPressure: PushPressure.light,
      brewMethod: BrewMethod.regular,
      notes: [
        Notes(time: "2:30", text: "Lightly swirl to bring grounds to bottom"),
      ],
    ),
    RecipeEntry(
      id: 5,
      title: "The Hoffman Special",
      description: "Hot cup that serves one",
      coffeeSettings: [
        CoffeeSettings(
          beanName: "JJBean",
          grindSetting: 17,
          coffeeAmount: 11,
          waterAmount: 200,
          waterTemp: 100,
          brewTime: 15,
          isHidden: true,
        ),
        CoffeeSettings(
          beanName: "Dark Xmas Gift from Parentals",
          grindSetting: 17,
          coffeeAmount: 12,
          waterAmount: 200,
          waterTemp: 86,
          brewTime: 15,
          isHidden: true,
        ),
      ],
      pushPressure: PushPressure.light,
      brewMethod: BrewMethod.regular,
      notes: [
        Notes(time: "2:30", text: "Lightly swirl to bring grounds to bottom"),
      ],
    ),
  ];

  EditMode editMode = EditMode.disabled;

  UnmodifiableListView<RecipeEntry> get recipes {
    return UnmodifiableListView(_recipes);
  }

  void changeEditMode() {
    if (editMode == EditMode.disabled) {
      editMode = EditMode.enabled;
      log("edit mode enabled");
    } else {
      editMode = EditMode.disabled;
      log("edit mode disabled");
    }
    notifyListeners();
  }

  void deleteRecipe(int id) {
    _recipes.removeWhere((recipe) => recipe.id == id);
    notifyListeners();
    log("Recipe of id $id deleted");
  }

  void editRecipe(String title, String? description, int id) {
    _recipes.firstWhere((recipe) => recipe.id == id).title = title;
    _recipes.firstWhere((recipe) => recipe.id == id).description = description;
    notifyListeners();
  }

  /// methods and variables for editing/adding settings to a recipe
  double? tempGrindSetting;
  double? tempCoffeeAmount;
  int? tempWaterAmount;
  int? tempWaterTemp;
  int? tempBrewTime;

  // currently active setting to adjust when editing/adding
  late SettingType activeSetting;

  /// used to activate/deactive editing of a setting for a recipe
  void settingOnTap(SettingType settingType) {
    if (activeSetting == settingType) {
      activeSetting = SettingType.none;
    } else {
      activeSetting = settingType;
    }
    notifyListeners();
  }

  /// defines which value is getting changed when sliding the slider
  void sliderOnChanged(double value, SettingType settingType) {
    switch (settingType) {
      case SettingType.grindSetting:
        tempGrindSetting = value;
        break;
      case SettingType.coffeeAmount:
        tempCoffeeAmount = value;
        break;
      case SettingType.waterAmount:
        tempWaterAmount = value.toInt();
        break;
      case SettingType.waterTemp:
        tempWaterTemp = value.toInt();
        break;
      case SettingType.brewTime:
        tempBrewTime = value.toInt();
        break;
      case SettingType.none:
        break;
    }
    notifyListeners();
  }
}

enum EditMode { enabled, disabled }
