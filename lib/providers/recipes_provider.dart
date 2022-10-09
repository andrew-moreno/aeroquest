import 'dart:collection';
import 'dart:developer';
import 'package:aeroquest/databases/coffee_beans_database.dart';
import 'package:aeroquest/models/coffee_bean.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:aeroquest/widgets/recipe_settings/widgets/settings_value.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:aeroquest/databases/recipe_settings_database.dart';
import 'package:aeroquest/databases/recipes_database.dart';
import 'package:aeroquest/models/recipe.dart';
import '../models/recipe_settings.dart';

class RecipesProvider extends ChangeNotifier {
  late List<Recipe> _recipes;
  late List<RecipeSettings> _recipeSettings;
  late List<CoffeeBean> _coffeeBeans;

  UnmodifiableListView<Recipe> get recipes {
    return UnmodifiableListView(_recipes);
  }

  UnmodifiableListView<RecipeSettings> get recipeSettings {
    return UnmodifiableListView(_recipeSettings);
  }

  UnmodifiableListView<CoffeeBean> get coffeeBeans {
    return UnmodifiableListView(_coffeeBeans);
  }

  cacheRecipesAndSettings() async {
    _recipes = await RecipesDatabase.instance.readAllRecipes();
    _recipeSettings =
        await RecipeSettingsDatabase.instance.readAllRecipeSettings();
    _coffeeBeans = await CoffeeBeansDatabase.instance.readAllCoffeeBeans();
  }

  EditMode editMode = EditMode.disabled;

  GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

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

  void deleteRecipe(int recipeId) async {
    _recipes.removeWhere((recipe) => recipe.id == recipeId);
    _recipeSettings.removeWhere(
        (recipeSetting) => recipeSetting.recipeEntryId == recipeId);
    await RecipesDatabase.instance.delete(recipeId);
    await RecipeSettingsDatabase.instance.deleteAllSettingsForRecipe(recipeId);
    notifyListeners();
    log("Recipe of id $recipeId deleted");
  }

  Future<void> editRecipe(Recipe recipeData) async {
    _recipes.firstWhere((recipe) => recipe.id == recipeData.id).title =
        recipeData.title;
    _recipes.firstWhere((recipe) => recipe.id == recipeData.id).description =
        recipeData.description;
    _recipes.firstWhere((recipe) => recipe.id == recipeData.id).pushPressure =
        recipeData.pushPressure;
    _recipes.firstWhere((recipe) => recipe.id == recipeData.id).brewMethod =
        recipeData.brewMethod;
    await RecipesDatabase.instance.update(recipeData);
    notifyListeners();
  }

  /// methods and variables for editing/adding settings to a recipe
  /// contain values for the currently edited/added setting
  SettingVisibility? tempSettingVisibility;
  int? tempBeanId;
  double? tempGrindSetting;
  double? tempCoffeeAmount;
  int? tempWaterAmount;
  int? tempWaterTemp;
  int? tempBrewTime;

  // currently active setting to adjust when editing/adding
  late SettingType activeSetting;

  /// used to activate/deactive editing of a setting for a recipe
  void selectSetting(SettingType settingType) {
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

  Future<void> deleteSetting(int settingId) async {
    _recipeSettings
        .removeWhere((recipeSetting) => recipeSetting.id == settingId);
    await RecipeSettingsDatabase.instance.delete(settingId);
    log("Recipe settings of setting id $settingId deleted");
    notifyListeners();
  }

  // when save button pressed
  Future<void> editSetting(RecipeSettings recipeSettingsData) async {
    RecipeSettings newCoffeeSettingsData = recipeSettingsData;
    if (recipeSettingsData.grindSetting != tempGrindSetting) {
      newCoffeeSettingsData.grindSetting = tempGrindSetting!;
      log("Grind setting set to $tempGrindSetting");
    }
    if (recipeSettingsData.coffeeAmount != tempCoffeeAmount) {
      newCoffeeSettingsData.coffeeAmount = tempCoffeeAmount!;
      log("Coffee amount set to $tempCoffeeAmount");
    }
    if (recipeSettingsData.waterAmount != tempWaterAmount) {
      newCoffeeSettingsData.waterAmount = tempWaterAmount!;
      log("Water amount set to $tempWaterAmount");
    }
    if (recipeSettingsData.waterTemp != tempWaterTemp) {
      newCoffeeSettingsData.waterTemp = tempWaterTemp!;
      log("Water temp set to $tempWaterTemp");
    }
    if (recipeSettingsData.brewTime != tempBrewTime) {
      newCoffeeSettingsData.brewTime = tempBrewTime!;
      log("Brew time set to $tempBrewTime");
    }
    if (recipeSettingsData.beanId != tempBeanId) {
      newCoffeeSettingsData.beanId = tempBeanId!;
      log("Bean id set to $tempBeanId");
    }
    if (RecipeSettings.stringToSettingVisibility(
            newCoffeeSettingsData.visibility) !=
        tempSettingVisibility) {
      newCoffeeSettingsData.visibility = describeEnum(tempSettingVisibility!);
      log("Visibility set to $tempSettingVisibility");
    }
    await RecipeSettingsDatabase.instance.update(newCoffeeSettingsData);
    notifyListeners();
  }
}

enum EditMode { enabled, disabled }
