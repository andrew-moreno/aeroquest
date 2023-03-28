import 'package:aeroquest/models/recipe_variables.dart';
import 'package:aeroquest/widgets/recipe_parameters_value.dart';
import 'package:flutter/material.dart';

class VariablesSliderProvider extends ChangeNotifier {
  /// Parameters used for generating/editing recipe variables
  ///
  /// These parameters are separate from RecipesProvider to avoid unnecessary
  /// rebuilds for widgets using RecipeProvider
  ///
  /// All values associated with each variable are set to null at all times
  /// except when editing recipe variables values using the editing modal sheet
  VariablesVisibility? tempVariablesVisibility;
  int? tempBeanId;
  double? tempGrindSetting;
  double? tempCoffeeAmount;
  double? tempWaterAmount;
  double? tempWaterTemp;
  int? tempBrewTime;

  int? tempRecipeStepTime;
  String? tempRecipeStepText;

  String? tempRecipeNoteText;

  /// Defines which value is getting changed when sliding the slider and
  /// assigns the appropriate variables value to [value]
  void sliderOnChanged(double value, ParameterType parameterType) {
    switch (parameterType) {
      case ParameterType.grindSetting:
        tempGrindSetting = value;
        break;
      case ParameterType.coffeeAmount:
        tempCoffeeAmount = value;
        break;
      case ParameterType.waterAmount:
        tempWaterAmount = value;
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

  /// Clears all temporary variable parameters by setting them to null
  void clearTempVariableParameters() {
    tempBeanId = null;
    tempGrindSetting = null;
    tempCoffeeAmount = null;
    tempWaterAmount = null;
    tempWaterTemp = null;
    tempBrewTime = null;
    tempVariablesVisibility = null;
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
