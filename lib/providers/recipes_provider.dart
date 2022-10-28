import 'dart:collection';

import 'package:aeroquest/databases/coffee_beans_database.dart';
import 'package:aeroquest/databases/notes_database.dart';
import 'package:aeroquest/models/coffee_bean.dart';
import 'package:aeroquest/models/note.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import "package:collection/collection.dart";

import 'package:aeroquest/widgets/recipe_parameters_value.dart';
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
  late SplayTreeMap<int, SplayTreeMap<int, Note>> _notes;
  late SplayTreeMap<int, Note> _tempNotes;

  EditMode editMode = EditMode.disabled;

  // form key for title and description
  GlobalKey<FormBuilderState> recipeIdentifiersFormKey =
      GlobalKey<FormBuilderState>();

  // form key for selecting a bean in the settings modal
  GlobalKey<FormBuilderState> settingsBeanFormKey =
      GlobalKey<FormBuilderState>();

  // form key for note text
  GlobalKey<FormBuilderState> recipeNotesFormKey =
      GlobalKey<FormBuilderState>();

  late PushPressure tempPushPressure;
  late BrewMethod tempBrewMethod;

  // currently active setting to adjust when editing/adding
  late ParameterType activeSlider;

  // variables for editing/adding settings to a recipe
  // contain values for the currently edited/added setting
  SettingVisibility? tempSettingVisibility;
  int? tempBeanId;
  double? tempGrindSetting;
  double? tempCoffeeAmount;
  int? tempWaterAmount;
  int? tempWaterTemp;
  int? tempBrewTime;

  int? tempNoteTime;

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

  UnmodifiableMapView<int, Map<int, Note>> get notes {
    return UnmodifiableMapView(_notes);
  }

  UnmodifiableMapView<int, Note> get tempNotes {
    return UnmodifiableMapView(_tempNotes);
  }

  Future<void> cacheRecipeData() async {
    _recipes = await RecipesDatabase.instance.readAllRecipes();
    _recipeSettings =
        await RecipeSettingsDatabase.instance.readAllRecipeSettings();
    _coffeeBeans = await CoffeeBeansDatabase.instance.readAllCoffeeBeans();
    _notes = await NotesDatabase.instance.readAllNotes();
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
    setTempNotes(null);
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
      title:
          recipeIdentifiersFormKey.currentState!.fields["recipeTitle"]!.value,
      description: recipeIdentifiersFormKey
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
    if (areSettingsChanged(newRecipe.id!)) {
      saveEditedRecipeSettings(newRecipe.id!);
    }
    if (areNotesChanged(newRecipe.id!)) {
      saveEditedNotes(newRecipe.id!);
    }
    notifyListeners();
  }

  bool isRecipeChanged({
    required String originalTitle,
    required String? originalDescription,
    required PushPressure originalPushPressure,
    required BrewMethod originalBrewMethod,
    required int recipeId,
  }) {
    bool recipePropertiesChangedCheck =
        (recipeIdentifiersFormKey.currentState!.fields["recipeTitle"]!.value !=
                originalTitle ||
            recipeIdentifiersFormKey
                    .currentState!.fields["recipeDescription"]?.value !=
                originalDescription ||
            originalPushPressure != tempPushPressure ||
            originalBrewMethod != tempBrewMethod);

    bool recipeSettingsChangedCheck = false;
    if (_tempRecipeSettings.isNotEmpty) {
      recipeSettingsChangedCheck = areSettingsChanged(recipeId);
    }

    bool notesChangedCheck = false;
    if (_tempNotes.isNotEmpty) {
      notesChangedCheck = areNotesChanged(recipeId);
    }

    return (recipePropertiesChangedCheck ||
        recipeSettingsChangedCheck ||
        notesChangedCheck);
  }

  /// used to activate/deactive editing of a setting for a recipe
  void selectSliderType(ParameterType parameterType) {
    if (activeSlider == parameterType) {
      activeSlider = ParameterType.none;
    } else {
      activeSlider = parameterType;
    }
    notifyListeners();
  }

  /// defines which value is getting changed when sliding the slider
  void sliderOnChanged(double value, ParameterType parameterType) {
    switch (parameterType) {
      case ParameterType.grindSetting:
        tempGrindSetting = value;
        break;
      case ParameterType.coffeeAmount:
        tempCoffeeAmount = value;
        break;
      case ParameterType.waterAmount:
        tempWaterAmount = value.toInt();
        break;
      case ParameterType.waterTemp:
        tempWaterTemp = value.toInt();
        break;
      case ParameterType.brewTime:
        tempBrewTime = value.toInt();
        break;
      case ParameterType.noteTime:
        tempNoteTime = value.toInt();
        break;
      case ParameterType.none:
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
    if (recipeSettings[recipeEntryId] == null) {
      _recipeSettings[recipeEntryId] = [];
    }
    // setting tempId to a unique number for this recipe
    int tempId;
    if (tempRecipeSettings.isEmpty) {
      if (_recipeSettings[recipeEntryId]!.isEmpty) {
        tempId = 0;
      } else {
        if (!_recipeSettings[recipeEntryId]!
            .isSorted((a, b) => a.id!.compareTo(b.id!))) {
          _recipeSettings[recipeEntryId]!
              .sort((a, b) => a.id!.compareTo(b.id!));
        }
        tempId = recipeSettings[recipeEntryId]![
                    recipeSettings[recipeEntryId]!.length - 1]
                .id! +
            1;
      }
    } else {
      if (!tempRecipeSettings.isSorted((a, b) => a.id!.compareTo(b.id!))) {
        tempRecipeSettings.sort((a, b) => a.id!.compareTo(b.id!));
      }
      tempId = tempRecipeSettings.last.id! + 1;
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
    Set idsInRecipeSettings = {};
    for (var recipeSetting in recipeSettings[recipeEntryId]!) {
      // used in update/add for loop
      idsInRecipeSettings.add(recipeSetting.id);

      // for deleting
      if (!tempRecipeSettings.contains(recipeSetting)) {
        CoffeeBean coffeeBean = _coffeeBeans
            .firstWhere((coffeeBean) => coffeeBean.id == recipeSetting.beanId);
        coffeeBean.associatedSettingsCount--;
        await CoffeeBeansDatabase.instance.update(coffeeBean);
        await RecipeSettingsDatabase.instance.delete(recipeSetting.id!);
      }
    }

    for (int i = 0; i < _tempRecipeSettings.length; i++) {
      // new id -> add
      if (!idsInRecipeSettings.contains(tempRecipeSettings[i].id)) {
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
        CoffeeBean coffeeBean = coffeeBeans.firstWhere(
            (coffeeBean) => coffeeBean.id == newCoffeeSettingsData.beanId);
        coffeeBean.associatedSettingsCount++;
        await CoffeeBeansDatabase.instance.update(coffeeBean);
        _tempRecipeSettings[i] = _tempRecipeSettings[i].copy(
            id: await RecipeSettingsDatabase.instance
                .create(newCoffeeSettingsData));
      }
      // id exists in recipe settings -> update or don't do anything if settings are the same
      else {
        // update because entries of same id
        if (recipeSettings[recipeEntryId]!.firstWhere((recipeSetting) =>
                recipeSetting.id == tempRecipeSettings[i].id) !=
            tempRecipeSettings[i]) {
          await RecipeSettingsDatabase.instance.update(tempRecipeSettings[i]);
        }
        // else do nothing
      }
    }

    _recipeSettings[recipeEntryId] = List.from(tempRecipeSettings);
    notifyListeners();
  }

  // Recipe method
  Future<void> tempAddNote(int recipeEntryId) async {
    if (notes[recipeEntryId] == null) {
      _notes[recipeEntryId] = SplayTreeMap();
    }
    // setting tempId to a unique number for this recipe
    int tempId;
    if (tempNotes.isEmpty) {
      if (notes[recipeEntryId]!.isEmpty) {
        tempId = 0;
      } else {
        tempId = _notes[recipeEntryId]!.lastKey()! + 1;
      }
    } else {
      tempId = _tempNotes.lastKey()! + 1;
    }
    Note newNote = Note(
      id: tempId,
      recipeEntryId: recipeEntryId,
      time: tempNoteTime!,
      text: recipeNotesFormKey.currentState!.fields["noteText"]!.value,
    );
    _tempNotes.addAll({tempId: newNote});
    notifyListeners();
  }

  Future<void> tempDeleteNote(int settingId) async {
    _tempNotes.remove(settingId);
    notifyListeners();
  }

  // initialize tempNotes
  void setTempNotes(int? recipeEntryId) {
    _tempNotes = SplayTreeMap<int, Note>.from(
        _notes[recipeEntryId] ?? SplayTreeMap<int, Note>());
  }

  // check if settings have been updated since details page load
  bool areNotesChanged(int recipeEntryId) {
    return !(const DeepCollectionEquality()
        .equals(_tempNotes, _notes[recipeEntryId]!));
  }

  // on saving changes to recipe details page
  // stores tempRecipeSettings in database and cache
  Future<void> saveEditedNotes(int recipeEntryId) async {
    // for deleting
    for (var key in notes[recipeEntryId]!.keys) {
      if (!tempNotes.containsKey(key)) {
        await RecipeSettingsDatabase.instance.delete(key);
      }
    }

    for (var key in tempNotes.keys) {
      // new id -> add
      if (!notes[recipeEntryId]!.containsKey(key)) {
        // for clearing tempId
        Note newNote = Note(
            recipeEntryId: tempNotes[key]!.recipeEntryId,
            time: tempNotes[key]!.time,
            text: tempNotes[key]!.text);
        _tempNotes[key] = _tempNotes[key]!
            .copy(id: await NotesDatabase.instance.create(newNote));
      }
      // id exists in recipe settings -> update or don't do anything if settings are the same
      else {
        // update because entries of same id
        if (notes[recipeEntryId]![key] != tempNotes[key]) {
          await NotesDatabase.instance.update(tempNotes[key]!);
        }
        // else do nothing
      }
    }

    _notes[recipeEntryId] = SplayTreeMap.from(tempNotes);
    notifyListeners();
  }
}

enum EditMode { enabled, disabled }
