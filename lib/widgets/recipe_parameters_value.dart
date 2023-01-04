import 'package:flutter/material.dart';
import 'package:aeroquest/constraints.dart';

class RecipeParameterValue extends StatelessWidget {
  /// Defines the widget for displaying recipe setting values
  ///
  /// eg. Grind: 17, Water Amount: 200, etc.
  const RecipeParameterValue({
    Key? key,
    required this.parameterValue,
    required this.parameterType,
  }) : super(key: key);

  /// Value to be displayed in the widget
  final num parameterValue;

  /// The type of value to display in the widget
  ///
  /// eg. grind, water amount, etc.
  final ParameterType parameterType;

  /// Generates the string representation of the parameter value based on
  /// the [parameterType]
  ///
  /// Throws an exception is [ParameterType.none] is passed
  String _parameterValue(ParameterType parameterType) {
    switch (parameterType) {
      case ParameterType.grindSetting: // double
        return parameterValue.toString();
      case ParameterType.coffeeAmount: // double
        return (parameterValue).toString() + "g";
      case ParameterType.waterAmount: // int
        return (parameterValue).toString() + "g";
      case ParameterType.waterTemp: // int
        return parameterValue.toString();
      case ParameterType.brewTime: // int
        return (parameterValue ~/ 6).toString() +
            ":" +
            (parameterValue % 6).toString() +
            "0";
      case ParameterType.recipeStepTime:
        return (parameterValue ~/ 6).toString() +
            ":" +
            (parameterValue % 6).toString() +
            "0";
      case ParameterType.none:
        throw Exception("ParameterType.none passed incorrectly");
    }
  }

  /// Converts the enum passed to [parameterType] to a string
  ///
  /// Throws an exception if [ParameterType.none] is passed
  String _parameterType(ParameterType parameterType) {
    switch (parameterType) {
      case ParameterType.grindSetting:
        return "Grind";
      case ParameterType.coffeeAmount:
        return "Coffee";
      case ParameterType.waterAmount:
        return "Water";
      case ParameterType.waterTemp:
        return "Temp";
      case ParameterType.brewTime:
        return "Time";
      case ParameterType.recipeStepTime:
        return "Time";
      case ParameterType.none:
        throw Exception("ParameterType.none passed incorrectly");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          _parameterValue(parameterType),
          style: const TextStyle(
            color: kAccent,
            fontFamily: "Poppins",
            fontSize: 19,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          _parameterType(parameterType),
          style: Theme.of(context)
              .textTheme
              .subtitle1!
              .copyWith(color: kAccentTransparent),
        ),
      ],
    );
  }
}

/// Defines all types of editable parameters for a recipe
///
/// eg. water amount, grind setting, recipe step time
enum ParameterType {
  recipeStepTime,
  grindSetting,
  coffeeAmount,
  waterAmount,
  waterTemp,
  brewTime,
  none
}
