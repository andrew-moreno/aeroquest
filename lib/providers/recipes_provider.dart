import 'dart:developer';
import 'package:aeroquest/databases/coffee_beans_database.dart';
import 'package:aeroquest/models/coffee_bean.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import "package:collection/collection.dart";

import 'package:aeroquest/widgets/recipe_settings/widgets/settings_value.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:aeroquest/databases/recipe_settings_database.dart';
import 'package:aeroquest/databases/recipes_database.dart';
import 'package:aeroquest/models/recipe.dart';
import '../models/recipe_settings.dart';

class RecipesProvider extends ChangeNotifier {
  late List<Recipe> _recipes;

  late List<CoffeeBean> _coffeeBeans;
  late Map<int, List<RecipeSettings>> _recipeSettings;
  late List<RecipeSettings> _tempRecipeSettings;

  EditMode editMode = EditMode.disabled;

  // form key for title and description
  GlobalKey<FormBuilderState> recipePropertiesFormKey =
      GlobalKey<FormBuilderState>();

  // form key for selecting a bean in the settings modal
  GlobalKey<FormBuilderState> settingsBeanFormKey =
      GlobalKey<FormBuilderState>();

  // currently active setting to adjust when editing/adding
  late SettingType activeSetting;

  // methods and variables for editing/adding settings to a recipe
  // contain values for the currently edited/added setting
  SettingVisibility? tempSettingVisibility;
  int? tempBeanId;
  double? tempGrindSetting;
  double? tempCoffeeAmount;
  int? tempWaterAmount;
  int? tempWaterTemp;
  int? tempBrewTime;

  UnmodifiableListView<Recipe> get recipes {
    return UnmodifiableListView(_recipes);
  }

  UnmodifiableListView<CoffeeBean> get coffeeBeans {
    return UnmodifiableListView(_coffeeBeans);
  }

  UnmodifiableMapView<int, List<RecipeSettings>> get recipeSettings {
    return UnmodifiableMapView(_recipeSettings);
  }

  UnmodifiableListView<RecipeSettings> get tempRecipeSettings {
    return UnmodifiableListView(_tempRecipeSettings);
  }

  cacheRecipesAndSettings() async {
    _recipes = await RecipesDatabase.instance.readAllRecipes();
    _recipeSettings =
        await RecipeSettingsDatabase.instance.readAllRecipeSettings();
    _coffeeBeans = await CoffeeBeansDatabase.instance.readAllCoffeeBeans();
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

  Future<Recipe> tempAddRecipe() async {
    int id = await RecipesDatabase.instance.getUnusedId();
    Recipe newRecipe = Recipe(
        id: id,
        title: "",
        description: "",
        pushPressure: "light",
        brewMethod: "regular");
    setTempRecipeSettings(null);
    changeEditMode();
    return newRecipe;
  }

  void deleteRecipe(int recipeId) async {
    _recipes.removeWhere((recipe) => recipe.id == recipeId);
    _recipeSettings.remove(recipeId);
    await RecipesDatabase.instance.delete(recipeId);
    await RecipeSettingsDatabase.instance.deleteAllSettingsForRecipe(recipeId);
    notifyListeners();
    log("Recipe of id $recipeId deleted");
  }

  Future<void> saveRecipe(Recipe recipeData) async {
    if (_recipes.isEmpty) {
      _recipes = [];
      _recipeSettings = {recipeData.id!: []};
      _recipes.add(recipeData);
      await RecipesDatabase.instance.create(recipeData);
    } else {
      int index = _recipes.indexWhere((recipe) => recipe.id == recipeData.id);
      if (index == -1) {
        _recipes.add(recipeData);
        await RecipesDatabase.instance.create(recipeData);
      } else {
        _recipes[index] = recipeData;
        await RecipesDatabase.instance.update(recipeData);
      }
    }
    saveEditedRecipeSettings(recipeData.id!);
    notifyListeners();
  }

  bool isRecipeChanged({
    required String originalTitle,
    required String? originalDescription,
    required int recipeId,
  }) {
    bool areRecipePropertiesChanged =
        (recipePropertiesFormKey.currentState!.fields["recipeTitle"]!.value !=
                originalTitle ||
            recipePropertiesFormKey
                    .currentState!.fields["recipeDescription"]?.value !=
                originalDescription);
    bool areRecipeSettingsChanged =
        (_tempRecipeSettings.isNotEmpty) ? areSettingsChanged(recipeId) : true;

    return (areRecipePropertiesChanged && areRecipeSettingsChanged);
  }

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

  void clearTempRecipeSettings() {
    _tempRecipeSettings.clear();
  }

  // initialize tempRecipeSettings
  void setTempRecipeSettings(int? recipeEntryId) {
    _tempRecipeSettings = List.from(_recipeSettings[recipeEntryId] ?? []);
  }

  // check if settings have been updated since details page load
  bool areSettingsChanged(int recipeEntryId) {
    return const DeepCollectionEquality()
        .equals(_tempRecipeSettings, _recipeSettings[recipeEntryId]!);
  }

  // adds new setting to tempRecipeSettings
  Future<void> tempAddSetting(int recipeEntryId) async {
    // temp id set as cannot be pulled from database because unknown how many ids needed
    int tempId;
    if (_tempRecipeSettings.isNotEmpty) {
      _tempRecipeSettings.sort((a, b) => a.id!.compareTo(b.id!));
      tempId = _tempRecipeSettings.last.id! + 1;
    } else {
      tempId = 0;
    }
    RecipeSettings newRecipeSettings = RecipeSettings(
      id: tempId,
      recipeEntryId: recipeEntryId,
      beanId: tempBeanId!,
      grindSetting: tempGrindSetting!,
      coffeeAmount: tempCoffeeAmount!,
      waterAmount: tempWaterAmount!,
      waterTemp: tempWaterTemp!,
      brewTime: tempBrewTime!,
      visibility: describeEnum(tempSettingVisibility!),
    );
    _tempRecipeSettings.add(newRecipeSettings);
    notifyListeners();
    log("Recipe setting added with id: ${newRecipeSettings.id}");
  }

  // deletes setting from tempRecipeSettings
  Future<void> tempDeleteSetting(int settingId) async {
    _tempRecipeSettings
        .removeWhere((recipeSetting) => recipeSetting.id == settingId);
    log("Recipe settings of setting id $settingId deleted");
    notifyListeners();
  }

  // when save button pressed
  // saves to temp recipe settings
  Future<void> editSetting(RecipeSettings recipeSettingsData) async {
    RecipeSettings newCoffeeSettingsData = recipeSettingsData.copy();

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
    _tempRecipeSettings[_tempRecipeSettings.indexWhere(
            (recipeSetting) => recipeSetting.id == recipeSettingsData.id)] =
        newCoffeeSettingsData;
    notifyListeners();
  }

  // on saving changes to recipe details page
  // stores tempRecipeSettings in database and cache
  Future<void> saveEditedRecipeSettings(int recipeEntryId) async {
    if (_recipeSettings[recipeEntryId] == null) {
      _recipeSettings[recipeEntryId] = [];
    }
    for (var recipeSetting in _recipeSettings[recipeEntryId]!) {
      if (!tempRecipeSettings.contains(recipeSetting)) {
        await RecipeSettingsDatabase.instance.delete(recipeSetting.id!);
      }
    }

    for (int i = 0; i < _tempRecipeSettings.length; i++) {
      if (!_recipeSettings[recipeEntryId]!.contains(tempRecipeSettings[i])) {
        // for clearing tempId
        RecipeSettings newCoffeeSettingsData = RecipeSettings(
          recipeEntryId: tempRecipeSettings[i].recipeEntryId,
          beanId: tempRecipeSettings[i].beanId,
          grindSetting: tempRecipeSettings[i].grindSetting,
          coffeeAmount: tempRecipeSettings[i].coffeeAmount,
          waterAmount: tempRecipeSettings[i].waterAmount,
          waterTemp: tempRecipeSettings[i].waterTemp,
          brewTime: tempRecipeSettings[i].brewTime,
          visibility: tempRecipeSettings[i].visibility,
        );
        _tempRecipeSettings[i] = _tempRecipeSettings[i].copy(
            id: await RecipeSettingsDatabase.instance
                .create(newCoffeeSettingsData));
      } else {
        await RecipeSettingsDatabase.instance.update(tempRecipeSettings[i]);
      }
    }
    _recipeSettings[recipeEntryId] = List.from(tempRecipeSettings);
    notifyListeners();
  }
}

enum EditMode { enabled, disabled }
