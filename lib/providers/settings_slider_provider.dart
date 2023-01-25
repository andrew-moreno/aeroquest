import 'package:aeroquest/models/recipe_settings.dart';
import 'package:aeroquest/widgets/recipe_parameters_value.dart';
import 'package:flutter/material.dart';

class SettingsSliderProvider extends ChangeNotifier {
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
  int? tempWaterAmount;
  double? tempWaterTemp;
  int? tempBrewTime;

  int? tempRecipeStepTime;
  String? tempRecipeStepText;

  String? tempRecipeNoteText;

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
        tempWaterTemp = value;
        break;
      case ParameterType.brewTime:
        tempBrewTime = value.toInt();
        break;
      case ParameterType.recipeStepTime:
        tempRecipeStepTime = value.toInt();
        break;
      case ParameterType.none:
        break;
    }
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

  /// Clears all temporary recipe step parameters by setting them to null
  void clearTempRecipeStepParameters() {
    tempRecipeStepText = null;
    tempRecipeStepTime = null;
  }

  /// Clears all temporary recipe step parameters by setting them to null
  void clearTempRecipeNoteParameters() {
    tempRecipeNoteText = null;
  }
}
