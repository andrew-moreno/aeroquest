import 'dart:collection';
import 'dart:developer';

import 'package:aeroquest/databases/coffee_beans_database.dart';
import 'package:aeroquest/databases/recipe_notes_database.dart';
import 'package:aeroquest/databases/recipe_steps_database.dart';
import 'package:aeroquest/models/coffee_bean.dart';
import 'package:aeroquest/models/recipe_note.dart';
import 'package:aeroquest/models/recipe_step.dart';
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
  /// which are ordered by key for ease of assignming temporary ids in
  /// [tempAddSetting]
  ///
  /// RecipeSettings objects must be updated in this map at the same time
  /// as they're updated in the database to reflect changes properly
  late Map<int, SplayTreeMap<int, RecipeSettings>> _recipeSettings;

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

  /// Reflects the recipe steps information from the recipe steps database, but
  /// sorted by recipe step time
  ///
  /// Mapped by their associated recipe id fist, then the recipe steps id
  ///
  /// RecipeSteps objects must be updated in this map at the same time as
  /// they're updated in the database to reflect changes properly
  late Map<int, SplayTreeMap<int, RecipeStep>> _recipeSteps;

  /// Holds a temporary map of the recipe steps associated with a particular
  /// recipe
  var _tempRecipeSteps = SplayTreeMap<int, RecipeStep>();

  /// Returns an unmodifaible version of [_recipeSteps]
  UnmodifiableMapView<int, Map<int, RecipeStep>> get recipeSteps {
    return UnmodifiableMapView(_recipeSteps);
  }

  /// Returns an unmodifiable version of [_tempRecipeSteps]
  UnmodifiableMapView<int, RecipeStep> get tempRecipeSteps {
    return UnmodifiableMapView(_tempRecipeSteps);
  }

  /// Reflects the recipe notes information from the recipe notes database
  ///
  /// Mapped by their associated recipe id fist, then the recipe note id
  ///
  /// RecipeNotes objects must be updated in this map at the same time as
  /// they're updated in the database to reflect changes properly
  late Map<int, SplayTreeMap<int, RecipeNote>> _recipeNotes;

  /// Holds a temporary map of the recipe notes associated with a particular
  /// recipe
  var _tempRecipeNotes = SplayTreeMap<int, RecipeNote>();

  /// Returns an unmodifaible version of [_recipeNotes]
  UnmodifiableMapView<int, Map<int, RecipeNote>> get recipeNotes {
    return UnmodifiableMapView(_recipeNotes);
  }

  /// Returns an unmodifiable version of [_tempRecipeNotes]
  UnmodifiableMapView<int, RecipeNote> get tempRecipeNotes {
    return UnmodifiableMapView(_tempRecipeNotes);
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

  /// Form key for title and description
  GlobalKey<FormBuilderState> recipeIdentifiersFormKey =
      GlobalKey<FormBuilderState>();

  /// Form key for selecting a bean in the settings modal
  GlobalKey<FormBuilderState> settingsBeanFormKey =
      GlobalKey<FormBuilderState>();

  /// Form key for recipe step text
  GlobalKey<FormBuilderState> recipeRecipeStepsFormKey =
      GlobalKey<FormBuilderState>();

  /// Form key for recipe note text
  GlobalKey<FormBuilderState> recipeRecipeNotesFormKey =
      GlobalKey<FormBuilderState>();

  late PushPressure tempPushPressure;
  late BrewMethod tempBrewMethod;

  /// Currently active setting to adjust when editing/adding
  late ParameterType activeSlider;

  /// Parameters used for generating/editing recipe settings
  ///
  /// These parameters are separate from RecipesProvider to avoid unnecessary
  /// rebuilds for widgets using RecipeProvider
  ///
  /// All values associated with each variable are set to null at all times
  /// except when editing recipe settings values using the editing modal sheet
  SettingVisibility? tempSettingVisibility;
  int? tempBeanId;
  double? tempGrindSetting;
  double? tempCoffeeAmount;
  double? tempWaterAmount;
  double? tempWaterTemp;
  int? tempBrewTime;

  int? tempRecipeStepTime;
  String? tempRecipeStepText;

  String? tempRecipeNoteText;

  /// Populates [_recipes], [_recipeSettings], [_recipeSteps], [_recipeNotes],
  /// and [_coffeeBeans] with data from their respective databases
  Future<void> cacheRecipeData() async {
    //await RecipeSettingsDatabase.instance.deleteDB();
    _recipes = await RecipesDatabase.instance.readAllRecipes();
    _recipeSettings =
        await RecipeSettingsDatabase.instance.readAllRecipeSettings();
    _recipeSteps = await RecipeStepsDatabase.instance.readAllRecipeSteps();
    _recipeNotes = await RecipeNotesDatabase.instance.readAllRecipeNotes();
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
    setTempRecipeSteps(null);
    setTempRecipeNotes(null);
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
  /// Prepares recipe settings, recipe steps, and recipe notes for editing
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

    tempPushPressure = Recipe.stringToPushPressure(_tempRecipe.pushPressure);
    tempBrewMethod = Recipe.stringToBrewMethod(_tempRecipe.brewMethod);

    /// Preparing recipe settings, recipe steps, and recipe notes for editing
    setTempRecipeSettings(recipeEntryId);
    setTempRecipeSteps(recipeEntryId);
    setTempRecipeNotes(recipeEntryId);
  }

  /// Deletes a recipe of [recipeEntryId] and its associated data
  /// - recipe of [recipeEntryId] removed from [_recipes]
  /// - all recipe settings associated with this recipe are deleted
  /// - all recipe steps associated with this recipe are deleted
  /// - all recipe notes associated with this recipe are deleted
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
    _recipeSteps.remove(recipeEntryId);
    _recipeNotes.remove(recipeEntryId);
    await RecipesDatabase.instance.delete(recipeEntryId);
    await RecipeSettingsDatabase.instance
        .deleteAllSettingsForRecipe(recipeEntryId);
    await RecipeStepsDatabase.instance
        .deleteAllRecipeStepsForRecipe(recipeEntryId);
    await RecipeNotesDatabase.instance
        .deleteAllRecipeNotesForRecipe(recipeEntryId);
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

    /// Saving recipe settings, recipe steps, and recipe notes if changes were
    /// made to them while editing recipe
    if (areSettingsChanged(tempRecipe.id!)) {
      await saveEditedRecipeSettings(tempRecipe.id!);
    }
    if (areRecipeStepsChanged(tempRecipe.id!)) {
      await saveEditedRecipeSteps(tempRecipe.id!);
    }
    if (areRecipeNotesChanged(tempRecipe.id!)) {
      await saveEditedRecipeNotes(tempRecipe.id!);
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

    bool recipeStepsChangedCheck = false;
    if (_tempRecipeSteps.isNotEmpty) {
      recipeStepsChangedCheck = areRecipeStepsChanged(recipeId);
    }

    bool recipeNotesChangedCheck = false;
    if (_tempRecipeNotes.isNotEmpty) {
      recipeNotesChangedCheck = areRecipeNotesChanged(recipeId);
    }

    return (recipePropertiesChangedCheck ||
        recipeSettingsChangedCheck ||
        recipeStepsChangedCheck ||
        recipeNotesChangedCheck);
  }

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

  /// Clears [_tempRecipeSettings], [_tempRecipeSteps], and [_tempRecipeNotes]
  /// and all temp recipe setting parameters
  void clearTempData() {
    _tempRecipeSettings.clear();
    _tempRecipeSteps.clear();
    _tempRecipeNotes.clear();
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
    notifyListeners();
  }

  /// Clears all temporary setting parameters by setting them to null
  void clearTempSettingParameters() {
    tempBeanId = null;
    tempGrindSetting = null;
    tempCoffeeAmount = null;
    tempWaterAmount = null;
    tempWaterTemp = null;
    tempBrewTime = null;
    tempSettingVisibility = null;
  }

  /// Saves data in [_tempRecipeSettings] to [recipeSettings] after edits and
  /// updates the recipe settings database accordingly
  ///
  /// First makes updates to the database and [associatedSettingsCount], then
  /// populates [_recipeSettings] with the data from [_tempRecipeSettings]
  /// at once
  Future<void> saveEditedRecipeSettings(int recipeEntryId) async {
    /// If [_tempRecipeSettings] doesn't contain a recipe setting that is in
    /// [_recipeSettings], delete that recipe setting from the database
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

    /// If [_tempRecipeSettings] contains a recipe setting that is not in
    /// [_recipeSettings], add that recipe setting to the database or make
    /// updates to the recipe settings if there are discrepencies between it
    /// and [_tempRecipeSettings]
    for (var id in tempRecipeSettings.keys.toList()) {
      /// New id -> add
      bool containsKey =
          recipeSettings[recipeEntryId]?.containsKey(id) ?? false;
      if (!containsKey) {
        /// Populate the recipe setting with a proper id from the database
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

        int newId = await RecipeSettingsDatabase.instance.create(
          newCoffeeSettingsData,
        );

        _tempRecipeSettings.addAll({
          newId: _tempRecipeSettings.remove(id)!.copy(id: newId),
        });
      }

      /// Id exists in [recipeSettings] but entry in [recipeSettings] is
      /// different from [tempRecipeSettings]
      else if (recipeSettings[recipeEntryId]![id] != tempRecipeSettings[id]) {
        await RecipeSettingsDatabase.instance.update(tempRecipeSettings[id]!);
      }
    }

    /// Commit data from [_tempRecipeSettings] to [_recipeSettings]
    _recipeSettings[recipeEntryId] = SplayTreeMap.from(_tempRecipeSettings);
    notifyListeners();
  }

  /// Sets [_tempRecipeSteps] to the recipe steps in [_recipeSteps] associated
  /// with [recipeEntryId]
  ///
  /// If [recipeEntryId] is null or doesn't exist, [_tempRecipeSteps] is set to
  /// an empty SplayTreeMap object
  /// - possibility that [recipeEntryId] doesn't exist in [_recipeSteps] when
  /// adding a new recipe
  void setTempRecipeSteps(int? recipeEntryId) {
    _tempRecipeSteps = SplayTreeMap<int, RecipeStep>.from(
        _recipeSteps[recipeEntryId] ?? SplayTreeMap<int, RecipeStep>());
  }

  /// Checks if the recipe steps associated with [recipeEntryId] have been
  /// updated since RecipeDetails page has loaded
  bool areRecipeStepsChanged(int recipeEntryId) {
    return !(const DeepCollectionEquality().equals(
        _tempRecipeSteps, _recipeSteps[recipeEntryId] ?? SplayTreeMap()));
  }

  /// Adds a new recipe step to [_tempRecipeSteps] using [recipeEntryId]
  /// as the key
  Future<void> tempAddRecipeStep(int recipeEntryId) async {
    /// Setting tempId to a unique number for this recipe
    int tempId;
    if (tempRecipeSteps.isEmpty) {
      /// [tempId] set to 0 if no recipe steps exist in the database for this
      /// recipe
      if (recipeSteps[recipeEntryId]?.isEmpty ?? true) {
        tempId = 0;
      } else {
        tempId = _recipeSteps[recipeEntryId]!.lastKey()! + 1;
      }
    } else {
      tempId = _tempRecipeSteps.lastKey()! + 1;
    }
    RecipeStep newRecipeStep = RecipeStep(
      id: tempId,
      recipeEntryId: recipeEntryId,
      time: tempRecipeStepTime!,
      text: recipeRecipeStepsFormKey
          .currentState!.fields["recipeStepText"]!.value,
    );
    _tempRecipeSteps.addAll({tempId: newRecipeStep});
    notifyListeners();
  }

  /// Deletes a recipe step from [_tempRecipeSteps] associated with the recipe
  /// setting id [settingId]
  Future<void> tempDeleteRecipeStep(int settingId) async {
    _tempRecipeSteps.remove(settingId);
    notifyListeners();
  }

  /// Sets all parameters in [_tempRecipeSteps] to ones that have been updated
  /// by the user when editing recipe steps
  Future<void> editRecipeStep(RecipeStep recipeStepData) async {
    _tempRecipeSteps[recipeStepData.id!] = recipeStepData.copy(
      text: recipeRecipeStepsFormKey
          .currentState!.fields["recipeStepText"]!.value,
      time: tempRecipeStepTime!,
    );
    notifyListeners();
  }

  /// Clears all temporary recipe step parameters by setting them to null
  void clearTempRecipeStepParameters() {
    tempRecipeStepText = null;
    tempRecipeStepTime = null;
  }

  /// Saves data in [_tempRecipeSteps] to [_recipeSteps] after edits and
  /// updates the recipe steps database accordingly
  ///
  /// First makes updates to the database and [associatedSettingsCount], then
  /// populates [_recipeSteps] with the all data from [_tempRecipeSteps] sorted
  /// by time
  Future<void> saveEditedRecipeSteps(int recipeEntryId) async {
    /// If [_tempRecipeSteps] doesn't contain a recipe step that is in
    /// [_recipeSteps], delete that recipe step from the database
    for (var id in recipeSteps[recipeEntryId]?.keys ?? const Iterable.empty()) {
      if (!tempRecipeSteps.containsKey(id)) {
        await RecipeSettingsDatabase.instance.delete(id);
      }
    }

    /// If [_tempRecipeSteps] contains a recipe step that is not in
    /// [_recipeSteps], add that recipe step to the database or make updates to
    /// the recipe step if there are discrepencies between it and
    /// [_tempRecipeSteps]
    for (var id in tempRecipeSteps.keys.toList()) {
      /// New id -> add
      bool containsKey = recipeSteps[recipeEntryId]?.containsKey(id) ?? false;
      if (!containsKey) {
        /// Populate the recipe step with a proper id from the database
        RecipeStep newRecipeStep = RecipeStep(
          recipeEntryId: tempRecipeSteps[id]!.recipeEntryId,
          time: tempRecipeSteps[id]!.time,
          text: tempRecipeSteps[id]!.text,
        );

        int newId = await RecipeStepsDatabase.instance.create(newRecipeStep);

        _tempRecipeSteps
            .addAll({newId: _tempRecipeSteps.remove(id)!.copy(id: newId)});
      }

      /// Id exists in [recipeSteps] but entry in [recipeSteps] is different
      /// from [tempRecipeSteps]
      else if (recipeSteps[recipeEntryId]![id] != tempRecipeSteps[id]) {
        await RecipeStepsDatabase.instance.update(tempRecipeSteps[id]!);
      }
      // else do nothing
    }

    /// Commit data from [_tempRecipeSteps] to [_recipeSteps]
    _recipeSteps[recipeEntryId] = SplayTreeMap.from(_tempRecipeSteps);
    notifyListeners();
  }

  /// Sets [_tempRecipeNotes] to the recipe notes in [_recipeNotes] associated
  /// with [recipeEntryId]
  ///
  /// If [recipeEntryId] is null or doesn't exist, [_tempRecipeNotes] is set to
  /// an empty SplayTreeMap object
  /// - possibility that [recipeEntryId] doesn't exist in [_recipeNotes] when
  /// adding a new recipe
  void setTempRecipeNotes(int? recipeEntryId) {
    _tempRecipeNotes = SplayTreeMap<int, RecipeNote>.from(
        _recipeNotes[recipeEntryId] ?? SplayTreeMap<int, RecipeNote>());
  }

  /// Checks if the recipe notes associated with [recipeEntryId] have been
  /// updated since RecipeDetails page has loaded
  bool areRecipeNotesChanged(int recipeEntryId) {
    return !(const DeepCollectionEquality().equals(
        _tempRecipeNotes, _recipeNotes[recipeEntryId] ?? SplayTreeMap()));
  }

  /// Adds a new recipe note to [_tempRecipeNotes] using [recipeEntryId]
  /// as the key
  Future<void> tempAddRecipeNote(int recipeEntryId) async {
    /// Setting tempId to a unique number for this recipe
    int tempId;
    if (tempRecipeNotes.isEmpty) {
      /// [tempId] set to 0 if no recipe notes exist in the database for this
      /// recipe
      if (recipeNotes[recipeEntryId]?.isEmpty ?? true) {
        tempId = 0;
      } else {
        tempId = _recipeNotes[recipeEntryId]!.lastKey()! + 1;
      }
    } else {
      tempId = _tempRecipeNotes.lastKey()! + 1;
    }
    RecipeNote newRecipeNote = RecipeNote(
      id: tempId,
      recipeEntryId: recipeEntryId,
      text: recipeRecipeNotesFormKey
          .currentState!.fields["recipeNoteText"]!.value,
    );
    _tempRecipeNotes.addAll({tempId: newRecipeNote});
    notifyListeners();
  }

  /// Deletes a recipe note from [_tempRecipeNotes] associated with the recipe
  /// setting id [settingId]
  Future<void> tempDeleteRecipeNote(int settingId) async {
    _tempRecipeNotes.remove(settingId);
    notifyListeners();
  }

  /// Sets all parameters in [_tempRecipeNotes] to ones that have been updated
  /// by the user when editing recipe notes
  Future<void> editRecipeNote(RecipeNote recipeNoteData) async {
    _tempRecipeNotes[recipeNoteData.id!] = recipeNoteData.copy(
      text: recipeRecipeNotesFormKey
          .currentState!.fields["recipeNoteText"]!.value,
    );
    notifyListeners();
  }

  /// Clears all temporary recipe note parameters by setting them to null
  void clearTempRecipeNoteParameters() {
    tempRecipeNoteText = null;
  }

  /// Saves data in [_tempRecipeNotes] to [_recipeNotes] after edits and
  /// updates the recipe notes database accordingly
  ///
  /// First makes updates to the database and [associatedSettingsCount], then
  /// populates [_recipeNotes] with the all data from [_tempRecipeNotes] sorted
  /// by time
  Future<void> saveEditedRecipeNotes(int recipeEntryId) async {
    /// If [_tempRecipeNotes] doesn't contain a recipe note that is in
    /// [_recipeNotes], delete that recipe note from the database
    for (var id in recipeNotes[recipeEntryId]?.keys ?? const Iterable.empty()) {
      if (!tempRecipeNotes.containsKey(id)) {
        await RecipeSettingsDatabase.instance.delete(id);
      }
    }

    /// If [_tempRecipeNotes] contains a recipe note that is not in
    /// [_recipeNotes], add that recipe note to the database or make updates to
    /// the recipe note if there are discrepencies between it and
    /// [_tempRecipeNotes]
    for (var id in tempRecipeNotes.keys.toList()) {
      /// New id -> add
      bool containsKey = recipeNotes[recipeEntryId]?.containsKey(id) ?? false;
      if (!containsKey) {
        /// Populate the recipe note with a proper id from the database
        RecipeNote newRecipeNote = RecipeNote(
          recipeEntryId: tempRecipeNotes[id]!.recipeEntryId,
          text: tempRecipeNotes[id]!.text,
        );

        int newId = await RecipeNotesDatabase.instance.create(newRecipeNote);

        _tempRecipeNotes
            .addAll({newId: _tempRecipeNotes.remove(id)!.copy(id: newId)});
      }

      /// Id exists in [recipeNotes] but entry in [recipeNotes] is different
      /// from [tempRecipeNotes]
      else if (recipeNotes[recipeEntryId]![id] != tempRecipeNotes[id]) {
        await RecipeNotesDatabase.instance.update(tempRecipeNotes[id]!);
      }
      // else do nothing
    }

    /// Commit data from [_tempRecipeNotes] to [_recipeNotes]
    _recipeNotes[recipeEntryId] = SplayTreeMap.from(_tempRecipeNotes);
    notifyListeners();
  }

  /// Adds a coffee bean to the database and [_coffeeBeans] and returns its id
  ///
  /// Used for when adding a bean via the snackbar on the recipe details screen
  /// that is activated when adding recipe settings with no coffee beans in
  /// the database
  Future<int> addBean(String beanName, String? description) async {
    final newCoffeeBean = await CoffeeBeansDatabase.instance.create(
      CoffeeBean(
        beanName: beanName,
        description: description,
        associatedSettingsCount: 0,
      ),
    );
    _coffeeBeans.addAll({newCoffeeBean.id!: newCoffeeBean});
    return newCoffeeBean.id!;
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
