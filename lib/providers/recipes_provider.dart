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
  /// Reflects recipe information from the recipes database, mapped by recipe
  /// id
  ///
  /// Recipe objects must be updated in this list at the same time as they're
  /// updated in the database to reflect changes properly
  late Map<int, Recipe> _recipes;

  /// Holds a temporary recipe object
  ///
  /// Used when edit mode is active
  late Recipe _tempRecipe;

  /// Returns an unmodifiable version of [_recipes]
  UnmodifiableMapView<int, Recipe> get recipes {
    return UnmodifiableMapView(_recipes);
  }

  /// Returns an unmodifiable version of [_tempRecipe]
  Recipe get tempRecipe {
    return _tempRecipe;
  }

  /// Reflects recipe settings information from the recipe settings database
  ///
  /// Mapped by their associated recipe id first, then the recipe settings id
  ///
  /// RecipeSettings objects must be updated in this map at the same time
  /// as they're updated in the database to reflect changes properly
  late SplayTreeMap<int, SplayTreeMap<int, RecipeSettings>> _recipeSettings;

  /// Holds a temporary map of the recipe settings associated with a particular
  /// recipe
  ///
  /// Used in the RecipeDetails page when in edit mode
  var _tempRecipeSettings = SplayTreeMap<int, RecipeSettings>();

  /// Returns an unmodifiable version of [_recipeSettings]
  UnmodifiableMapView<int, Map<int, RecipeSettings>> get recipeSettings {
    return UnmodifiableMapView(_recipeSettings);
  }

  /// Returns an unmodifiable version of [_tempRecipeSettings]
  UnmodifiableMapView<int, RecipeSettings> get tempRecipeSettings {
    return UnmodifiableMapView(_tempRecipeSettings);
  }

  late SplayTreeMap<int, SplayTreeMap<int, Note>> _notes;
  var _tempNotes = SplayTreeMap<int, Note>();

  UnmodifiableMapView<int, Map<int, Note>> get notes {
    return UnmodifiableMapView(_notes);
  }

  UnmodifiableMapView<int, Note> get tempNotes {
    return UnmodifiableMapView(_tempNotes);
  }

  /// Reflects coffee bean information from the coffee bean database mapped by
  /// id
  ///
  /// Coffee bean objects must be updated in this map at the same time as
  /// they're updated in the database to reflect changes properly
  ///
  /// Required for:
  /// - updating the AssociatedSettingsCount property of coffee
  ///   beans when adding or deleting recipe settings
  /// - displaying a list of coffee beans in the drop down menu when editing a
  ///   recipe setting
  /// - adding coffee beans using the snack bar that is displayed when adding
  ///   a recipe setting with no coffee beans in the database
  late Map<int, CoffeeBean> _coffeeBeans;

  /// Returns an unmodifiable version of [_coffeeBeans]
  UnmodifiableMapView<int, CoffeeBean> get coffeeBeans {
    return UnmodifiableMapView(_coffeeBeans);
  }

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

  /// Populates [_recipes], [_recipeSettings], [_notes], and [_coffeeBeans]
  /// with data from their respective databases
  Future<void> cacheRecipeData() async {
    _recipes = await RecipesDatabase.instance.readAllRecipes();
    _recipeSettings =
        await RecipeSettingsDatabase.instance.readAllRecipeSettings();
    _notes = await NotesDatabase.instance.readAllNotes();
    _coffeeBeans = await CoffeeBeansDatabase.instance.readAllCoffeeBeans();
  }

  /// Change edit mode to the opposite value
  void setEditMode(EditMode newEditMode) {
    if (editMode != newEditMode) {
      editMode = newEditMode;
    }
  }

  /// Used to prepare temp properties for when a new recipe is being added
  ///
  /// Returns [tempRecipe]
  Future<Recipe> tempAddRecipe() async {
    await setTempRecipe(null);
    setTempRecipeSettings(null);
    setTempNotes(null);
    return tempRecipe;
  }

  /// Sets [_tempRecipe] to a Recipe object
  /// - If [recipeEntryId] is null: adding new recipe. Sets a new Recipe object
  ///   to [_tempRecipe] with default/empty values.
  /// - If [recipeEntryId] is passed a value: editing existing recipe. Sets
  ///   [_tempRecipe] to the Recipe object that is currently being edited
  ///
  /// Sets [tempPushPressure] and [tempBrewMethod] to the values initialized
  /// in [_tempRecipe]
  ///
  /// Prepares recipe settings and notes for editing
  Future<void> setTempRecipe(int? recipeEntryId) async {
    // Adding new recipe
    if (recipeEntryId == null) {
      int id = await RecipesDatabase.instance.getUnusedId();
      _tempRecipe = Recipe(
          id: id,
          title: "",
          description: "",
          pushPressure: "light",
          brewMethod: "regular");
    }
    // Editing existing recipe
    else if (_recipes.containsKey(recipeEntryId)) {
      _tempRecipe = _recipes[recipeEntryId]!;
    }

    /// Setting temp recipe not required when recipe doesn't exist. For case
    /// where exiting recipe details page
    /// TODO: WHAT DOES THIS MEAN????
    tempPushPressure = Recipe.stringToPushPressure(_tempRecipe.pushPressure);
    tempBrewMethod = Recipe.stringToBrewMethod(_tempRecipe.brewMethod);

    /// Preparing recipe settings and notes for editing
    setTempRecipeSettings(recipeEntryId);
    setTempNotes(recipeEntryId);
  }

  /// Deletes a recipe of [recipeEntryId] and its associated data
  /// - recipe of [recipeEntryId] removed from [_recipes]
  /// - all recipe settings associated with this recipe are deleted
  /// - all notes associated with this recipe are deleted
  /// - coffee beans associated with this recipe have their
  ///   associatedSettingsCount decreased by one
  ///
  /// Throws an exception if [recipeEntryId] does not exist in [_recipes]
  Future<void> deleteRecipe(int recipeEntryId) async {
    if (!_recipes.containsKey(recipeEntryId)) {
      throw Exception(
          "recipeEntryId of $recipeEntryId does not exist in _recipes");
    }

    /// Decrementing all associatedSettingsCounts for associated coffee beans
    recipeSettings[recipeEntryId]?.forEach((recipeSettingId, value) async {
      editAssociatedSettingsCount(
        recipeSettings[recipeEntryId]![recipeSettingId]!.beanId,
        AssociatedSettingsCountEditType.decrement,
      );
    });
    _recipes.remove(recipeEntryId);
    _recipeSettings.remove(recipeEntryId);
    _notes.remove(recipeEntryId);
    await RecipesDatabase.instance.delete(recipeEntryId);
    await RecipeSettingsDatabase.instance
        .deleteAllSettingsForRecipe(recipeEntryId);
    await NotesDatabase.instance.deleteAllNotesForRecipe(recipeEntryId);
    notifyListeners();
  }

  /// Saves the current recipe being added/edited to [_recipes] using data
  /// from [_tempRecipe]
  Future<void> saveRecipe() async {
    /// Updating [_tempRecipe] with current values to be saved to [_recipe]
    _tempRecipe.title =
        recipeIdentifiersFormKey.currentState!.fields["recipeTitle"]!.value;
    _tempRecipe.description = recipeIdentifiersFormKey
        .currentState!.fields["recipeDescription"]?.value;
    _tempRecipe.pushPressure = describeEnum(tempPushPressure);
    _tempRecipe.brewMethod = describeEnum(tempBrewMethod);

    /// Adding [_tempRecipe] to [_recipes] or editing existing recipe with data
    /// from [_tempRecipe]
    if (_recipes.isEmpty || !_recipes.containsKey(tempRecipe.id)) {
      _recipes.addAll({tempRecipe.id!: tempRecipe});
      await RecipesDatabase.instance.create(tempRecipe);
    } else {
      _recipes[tempRecipe.id!] = tempRecipe;
      await RecipesDatabase.instance.update(tempRecipe);
    }

    /// Saving recipe settings and notes if changes were made to them while
    /// editing recipe
    if (areSettingsChanged(tempRecipe.id!)) {
      await saveEditedRecipeSettings(tempRecipe.id!);
    }
    if (areNotesChanged(tempRecipe.id!)) {
      await saveEditedNotes(tempRecipe.id!);
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
    /// Checks title, description, push pressure, and brew method
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

  ///TODO: make slider related things their own provider so rebuilds don't
  ///happen when changing slider
  /// Used to activate/deactivate a particular recipe settings slider when
  /// editing recipe setting values
  ///
  /// When a value is clicked while no other setting parameters are active,
  /// that particular slider will become active (eg. water amount, grind
  /// setting, etc.). If the value is already active, slider of
  /// [ParameterType.none] will be active, deactivating all other sliders
  void selectSliderType(ParameterType parameterType) {
    if (activeSlider == parameterType) {
      activeSlider = ParameterType.none;
    } else {
      activeSlider = parameterType;
    }
    notifyListeners();
  }

  /// Defines which value is getting changed when sliding the slider and
  /// assigns the appropriate settings value to [value]
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

  /// Clears [_tempRecipeSettings] and [_tempNotes]
  void clearTempNotesAndRecipeSettings() {
    _tempRecipeSettings.clear();
    _tempNotes.clear();
  }

  /// Sets [_tempRecipeSettings] to the recipe settings in [_recipeSettings]
  /// associated with [recipeEntryId]
  ///
  /// If [recipeEntryId] is null or doesn't exist, [_tempRecipeSettings] is set
  /// to an empty SplayTreeMap object
  /// - possibility that [recipeEntryId] doesn't exist in [_recipeSettings]
  ///   when adding a new recipe.
  void setTempRecipeSettings(int? recipeEntryId) {
    _tempRecipeSettings = SplayTreeMap<int, RecipeSettings>.from(
        _recipeSettings[recipeEntryId] ?? SplayTreeMap<int, RecipeSettings>());
  }

  /// Checks if the recipe settings associated with [recipeEntryId] have been
  /// updated since RecipeDetails page has loaded
  bool areSettingsChanged(int recipeEntryId) {
    return !(const DeepCollectionEquality().equals(
        _tempRecipeSettings, _recipeSettings[recipeEntryId] ?? SplayTreeMap()));
  }

  /// Adds a new recipe setting to [_tempRecipeSettings] using [recipeEntryId]
  /// as the key
  void tempAddSetting(int recipeEntryId) {
    /// Setting tempId to a unique number for this recipe
    int tempId;
    if (tempRecipeSettings.isEmpty) {
      /// [tempId] set to 0 if no recipe settings exist in the database for
      /// this recipe
      if (_recipeSettings[recipeEntryId]?.isEmpty ?? true) {
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

  /// Deletes a recipe setting from [_tempRecipeSettings] associated with the
  /// recipe setting id [settingId]
  Future<void> tempDeleteSetting(int settingId) async {
    _tempRecipeSettings.remove(settingId);
    notifyListeners();
  }

  /// Sets all parameters in [_tempRecipeSettings] to ones that have been
  /// updated by the user when editing recipe settings
  ///
  /// Afterwards, all temporary settings parameters are set to null
  void editSetting(RecipeSettings recipeSettingsData) {
    _tempRecipeSettings[recipeSettingsData.id!] = recipeSettingsData.copy(
      beanId: tempBeanId!,
      grindSetting: tempGrindSetting!,
      coffeeAmount: tempCoffeeAmount!,
      waterAmount: tempWaterAmount!,
      waterTemp: tempWaterTemp!,
      brewTime: tempBrewTime!,
      visibility: describeEnum(tempSettingVisibility!),
    );
    //clearTempSettingParameters();
    notifyListeners();
  }

  ///TODO: add this when fixing editing
  // /// Clears all temporary setting parameters by setting them to null
  // void clearTempSettingParameters() {
  //   tempBeanId = null;
  //   tempGrindSetting = null;
  //   tempCoffeeAmount = null;
  //   tempWaterAmount = null;
  //   tempWaterTemp = null;
  //   tempBrewTime = null;
  //   tempSettingVisibility = null;
  // }

  // on saving changes to recipe details page
  // stores tempRecipeSettings in database and cache
  Future<void> saveEditedRecipeSettings(int recipeEntryId) async {
    // for deleting
    for (var id
        in recipeSettings[recipeEntryId]?.keys ?? const Iterable.empty()) {
      if (!tempRecipeSettings.containsKey(id)) {
        editAssociatedSettingsCount(
          recipeSettings[recipeEntryId]![id]!.beanId,
          AssociatedSettingsCountEditType.decrement,
        );
        await RecipeSettingsDatabase.instance.delete(id);
      }
    }

    List<int> keys = tempRecipeSettings.keys.toList();
    for (var id in keys) {
      // new id -> add
      bool containsKey =
          recipeSettings[recipeEntryId]?.containsKey(id) ?? false;
      if (!containsKey) {
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
        editAssociatedSettingsCount(
          newCoffeeSettingsData.beanId,
          AssociatedSettingsCountEditType.increment,
        );

        int newId =
            await RecipeSettingsDatabase.instance.create(newCoffeeSettingsData);
        _tempRecipeSettings
            .addAll({newId: _tempRecipeSettings[id]!.copy(id: newId)});
        _tempRecipeSettings.remove(id);
      }

      /// Id exists in recipe settings but entry in [recipeSettings] is
      /// different from [tempRecipeSettings]
      else if (recipeSettings[recipeEntryId]![id] != tempRecipeSettings[id]) {
        // update because entries of same id
        //recipeSettings[recipeEntryId]![id] = tempRecipeSettings[id]!;
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

  /// Adds a coffee bean to the database and [_coffeeBeans]
  ///
  /// Used for when adding a bean via the snackbar on the recipe details screen
  /// that is activated when adding recipe settings with no coffee beans in
  /// the database
  Future<void> addBean(String beanName, String? description) async {
    final newCoffeeBean = await CoffeeBeansDatabase.instance.create(
      CoffeeBean(
        beanName: beanName,
        description: description,
        associatedSettingsCount: 0,
      ),
    );
    _coffeeBeans.addAll({newCoffeeBean.id!: newCoffeeBean});
  }

  /// Either increments or decrements the AssociatedSettingsCount property of
  /// a coffee bean in [_coffeeBeans] and updates the database with that value
  /// for that coffee bean
  Future<void> editAssociatedSettingsCount(
    int beanId,
    AssociatedSettingsCountEditType editType,
  ) async {
    if (editType == AssociatedSettingsCountEditType.increment) {
      _coffeeBeans[beanId]!.associatedSettingsCount++;
    } else {
      _coffeeBeans[beanId]!.associatedSettingsCount--;
    }
    await CoffeeBeansDatabase.instance.update(coffeeBeans[beanId]!);
    log("Associated settings count ${describeEnum(editType)}ed "
        "for bean with id: ${_coffeeBeans[beanId]!.id.toString()}");
  }
}

enum EditMode { enabled, disabled }

/// Possible edits that can be made to the AssociatedSettingsCount property
/// of a coffee bean
enum AssociatedSettingsCountEditType { increment, decrement }
