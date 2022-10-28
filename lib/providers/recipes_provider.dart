import 'dart:collection';
import 'dart:developer';

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
  late Map<int, CoffeeBean> _coffeeBeans;
  late SplayTreeMap<int, SplayTreeMap<int, RecipeSettings>> _recipeSettings;
  late SplayTreeMap<int, RecipeSettings> _tempRecipeSettings;
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
  String? tempNoteText;

  UnmodifiableListView<Recipe> get recipes {
    return UnmodifiableListView(_recipes);
  }

  Recipe get tempRecipe {
    return _tempRecipe;
  }

  UnmodifiableMapView<int, CoffeeBean> get coffeeBeans {
    return UnmodifiableMapView(_coffeeBeans);
  }

  UnmodifiableMapView<int, Map<int, RecipeSettings>> get recipeSettings {
    return UnmodifiableMapView(_recipeSettings);
  }

  UnmodifiableMapView<int, RecipeSettings> get tempRecipeSettings {
    return UnmodifiableMapView(_tempRecipeSettings);
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
    } else if (_recipes.any((recipe) => recipe.id == recipeEntryId)) {
      _tempRecipe = _recipes.firstWhere((recipe) => recipe.id == recipeEntryId);
    }
    // setting temp recipe not required when recipe doesn't exist
    // for case where exiting recipe details page
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
      _recipeSettings[newRecipe.id!] = SplayTreeMap();
      _notes[newRecipe.id!] = SplayTreeMap();
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
    _tempRecipeSettings = SplayTreeMap<int, RecipeSettings>.from(
        _recipeSettings[recipeEntryId] ?? SplayTreeMap<int, RecipeSettings>());
  }

  // check if settings have been updated since details page load
  bool areSettingsChanged(int recipeEntryId) {
    return !(const DeepCollectionEquality().equals(
        _tempRecipeSettings, _recipeSettings[recipeEntryId] ?? SplayTreeMap()));
  }

  // adds new setting to tempRecipeSettings
  Future<void> tempAddSetting(int recipeEntryId) async {
    if (recipeSettings[recipeEntryId] == null) {
      _recipeSettings[recipeEntryId] = SplayTreeMap<int, RecipeSettings>();
    }
    // setting tempId to a unique number for this recipe
    int tempId;
    if (tempRecipeSettings.isEmpty) {
      if (_recipeSettings[recipeEntryId]!.isEmpty) {
        tempId = 0;
      } else {
        tempId = _recipeSettings[recipeEntryId]!.lastKey()! + 1;
      }
    } else {
      tempId = _tempRecipeSettings.lastKey()! + 1;
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
    _tempRecipeSettings.addAll({tempId: newRecipeSettings});
    notifyListeners();
  }

  // deletes setting from tempRecipeSettings
  Future<void> tempDeleteSetting(int settingId) async {
    _tempRecipeSettings.remove(settingId);
    notifyListeners();
  }

  // when save button pressed
  // saves to temp recipe settings
  Future<void> editSetting(RecipeSettings recipeSettingsData, key) async {
    log(key.toString());
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
    _tempRecipeSettings[recipeSettingsData.id!] = newCoffeeSettingsData;
    notifyListeners();
  }

  // on saving changes to recipe details page
  // stores tempRecipeSettings in database and cache
  Future<void> saveEditedRecipeSettings(int recipeEntryId) async {
    // for deleting
    for (var id in recipeSettings[recipeEntryId]!.keys) {
      if (!tempRecipeSettings.containsKey(id)) {
        CoffeeBean coffeeBean =
            _coffeeBeans[recipeSettings[recipeEntryId]![id]!.beanId]!;

        coffeeBean.associatedSettingsCount--;
        await CoffeeBeansDatabase.instance.update(coffeeBean);
        await RecipeSettingsDatabase.instance.delete(id);
      }
    }

    List<int> keys = tempRecipeSettings.keys.toList();
    for (var id in keys) {
      // new id -> add
      if (!recipeSettings[recipeEntryId]!.containsKey(id)) {
        // for clearing tempId
        RecipeSettings newCoffeeSettingsData = RecipeSettings(
          recipeEntryId: tempRecipeSettings[id]!.recipeEntryId,
          beanId: tempRecipeSettings[id]!.beanId,
          grindSetting: tempRecipeSettings[id]!.grindSetting,
          coffeeAmount: tempRecipeSettings[id]!.coffeeAmount,
          waterAmount: tempRecipeSettings[id]!.waterAmount,
          waterTemp: tempRecipeSettings[id]!.waterTemp,
          brewTime: tempRecipeSettings[id]!.brewTime,
          visibility: tempRecipeSettings[id]!.visibility,
        );
        CoffeeBean coffeeBean = _coffeeBeans[newCoffeeSettingsData.beanId]!;
        coffeeBean.associatedSettingsCount++;
        await CoffeeBeansDatabase.instance.update(coffeeBean);
        int newId =
            await RecipeSettingsDatabase.instance.create(newCoffeeSettingsData);
        _tempRecipeSettings[newId] = _tempRecipeSettings[id]!.copy(id: newId);
        _tempRecipeSettings.remove(id);
      }
      // id exists in recipe settings -> update or don't do anything if settings are the same
      else if (recipeSettings[recipeEntryId]![id] != tempRecipeSettings[id]) {
        // update because entries of same id
        await RecipeSettingsDatabase.instance.update(tempRecipeSettings[id]!);
      }
      // else do nothing
    }

    _recipeSettings[recipeEntryId] = SplayTreeMap.from(_tempRecipeSettings);
    notifyListeners();
  }

  // Recipe method
  Future<void> tempAddNote(int recipeEntryId) async {
    if (notes[recipeEntryId] == null) {
      _notes[recipeEntryId] = SplayTreeMap<int, Note>();
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
        .equals(_tempNotes, _notes[recipeEntryId] ?? SplayTreeMap()));
  }

  // on saving changes to recipe details page
  // stores tempRecipeSettings in database and cache
  Future<void> saveEditedNotes(int recipeEntryId) async {
    // for deleting
    for (var id in notes[recipeEntryId]!.keys) {
      if (!tempNotes.containsKey(id)) {
        await RecipeSettingsDatabase.instance.delete(id);
      }
    }
    List<int> keys = tempNotes.keys.toList();
    for (var id in keys) {
      // new id -> add
      if (!notes[recipeEntryId]!.containsKey(id)) {
        // for clearing tempId
        Note newNote = Note(
            recipeEntryId: tempNotes[id]!.recipeEntryId,
            time: tempNotes[id]!.time,
            text: tempNotes[id]!.text);
        int newId = await NotesDatabase.instance.create(newNote);
        _tempNotes[newId] = _tempNotes[id]!.copy(id: newId);
        _tempNotes.remove(id);
      }
      // id exists in recipe settings -> update or don't do anything if settings are the same
      else if (notes[recipeEntryId]![id] != tempNotes[id]) {
        // update because entries of same id
        await NotesDatabase.instance.update(tempNotes[id]!);
      }
      // else do nothing
    }

    _notes[recipeEntryId] = SplayTreeMap.from(tempNotes);
    notifyListeners();
  }

  // when save button pressed
  // saves to tempNotes
  Future<void> editNote(Note noteData) async {
    Note newNoteData = noteData.copy();

    if (noteData.time != tempNoteTime) {
      newNoteData.time = tempNoteTime!;
    }
    if (noteData.text !=
        recipeNotesFormKey.currentState!.fields["noteText"]!.value) {
      newNoteData.text =
          recipeNotesFormKey.currentState!.fields["noteText"]!.value;
    }
    _tempNotes[noteData.id!] = newNoteData;
    notifyListeners();
  }
}

enum EditMode { enabled, disabled }
