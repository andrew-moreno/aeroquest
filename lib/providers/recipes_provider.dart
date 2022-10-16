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
  late Recipe _tempRecipe;
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

  late PushPressure tempPushPressure;
  late BrewMethod tempBrewMethod;

  // currently active setting to adjust when editing/adding
  late SettingType activeSetting;

  // variables for editing/adding settings to a recipe
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

  Recipe get tempRecipe {
    return _tempRecipe;
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
    } else {
      editMode = EditMode.disabled;
    }
    notifyListeners();
  }

  Future<Recipe> tempAddRecipe() async {
    await setTempRecipe(null);
    setTempRecipeSettings(null);
    changeEditMode();
    return tempRecipe;
  }

  Future<void> setTempRecipe(int? recipeEntryId) async {
    if (recipeEntryId == null) {
      int id = await RecipesDatabase.instance.getUnusedId();
      _tempRecipe = Recipe(
          id: id,
          title: "",
          description: "",
          pushPressure: "light",
          brewMethod: "regular");
    } else {
      _tempRecipe = _recipes.firstWhere((recipe) => recipe.id == recipeEntryId);
    }
    tempPushPressure = Recipe.stringToPushPressure(_tempRecipe.pushPressure);
    tempBrewMethod = Recipe.stringToBrewMethod(_tempRecipe.brewMethod);
  }

  void deleteRecipe(int recipeId) async {
    _recipes.removeWhere((recipe) => recipe.id == recipeId);
    _recipeSettings.remove(recipeId);
    await RecipesDatabase.instance.delete(recipeId);
    await RecipeSettingsDatabase.instance.deleteAllSettingsForRecipe(recipeId);
    notifyListeners();
  }

  Future<void> saveRecipe() async {
    Recipe newRecipe = _tempRecipe.copy(
      title: recipePropertiesFormKey.currentState!.fields["recipeTitle"]!.value,
      description: recipePropertiesFormKey
          .currentState!.fields["recipeDescription"]?.value,
      pushPressure: describeEnum(tempPushPressure),
      brewMethod: describeEnum(tempBrewMethod),
    );
    if (_recipes.isEmpty) {
      _recipes = [];
      _recipeSettings = {newRecipe.id!: []};
      _recipes.add(newRecipe);
      await RecipesDatabase.instance.create(newRecipe);
    } else {
      int index = _recipes.indexWhere((recipe) => recipe.id == newRecipe.id);
      if (index == -1) {
        _recipes.add(newRecipe);
        await RecipesDatabase.instance.create(newRecipe);
      } else {
        _recipes[index] = newRecipe;
        await RecipesDatabase.instance.update(newRecipe);
      }
    }
    saveEditedRecipeSettings(newRecipe.id!);
    notifyListeners();
  }

  bool isRecipeChanged({
    required String originalTitle,
    required String? originalDescription,
    required PushPressure originalPushPressure,
    required BrewMethod originalBrewMethod,
    required int recipeId,
  }) {
    bool areRecipePropertiesChanged =
        (recipePropertiesFormKey.currentState!.fields["recipeTitle"]!.value !=
                originalTitle ||
            recipePropertiesFormKey
                    .currentState!.fields["recipeDescription"]?.value !=
                originalDescription ||
            originalPushPressure != tempPushPressure ||
            originalBrewMethod != tempBrewMethod);

    bool areRecipeSettingsChanged = false;
    if (_tempRecipeSettings.isNotEmpty) {
      areRecipeSettingsChanged = areSettingsChanged(recipeId);
    }

    return (areRecipePropertiesChanged || areRecipeSettingsChanged);
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
    return !(const DeepCollectionEquality()
        .equals(_tempRecipeSettings, _recipeSettings[recipeEntryId]!));
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
  }

  // deletes setting from tempRecipeSettings
  Future<void> tempDeleteSetting(int settingId) async {
    _tempRecipeSettings
        .removeWhere((recipeSetting) => recipeSetting.id == settingId);
    notifyListeners();
  }

  // when save button pressed
  // saves to temp recipe settings
  Future<void> editSetting(RecipeSettings recipeSettingsData) async {
    RecipeSettings newCoffeeSettingsData = recipeSettingsData.copy();

    if (recipeSettingsData.grindSetting != tempGrindSetting) {
      newCoffeeSettingsData.grindSetting = tempGrindSetting!;
    }
    if (recipeSettingsData.coffeeAmount != tempCoffeeAmount) {
      newCoffeeSettingsData.coffeeAmount = tempCoffeeAmount!;
    }
    if (recipeSettingsData.waterAmount != tempWaterAmount) {
      newCoffeeSettingsData.waterAmount = tempWaterAmount!;
    }
    if (recipeSettingsData.waterTemp != tempWaterTemp) {
      newCoffeeSettingsData.waterTemp = tempWaterTemp!;
    }
    if (recipeSettingsData.brewTime != tempBrewTime) {
      newCoffeeSettingsData.brewTime = tempBrewTime!;
    }
    if (recipeSettingsData.beanId != tempBeanId) {
      newCoffeeSettingsData.beanId = tempBeanId!;
    }
    if (RecipeSettings.stringToSettingVisibility(
            newCoffeeSettingsData.visibility) !=
        tempSettingVisibility) {
      newCoffeeSettingsData.visibility = describeEnum(tempSettingVisibility!);
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

  // Recipe method

}

enum EditMode { enabled, disabled }
