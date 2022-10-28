import 'package:flutter/material.dart';
import 'package:aeroquest/constraints.dart';

// defines the template for displaying recipe information values
// eg. grind: 17
class RecipeParameterValue extends StatelessWidget {
  const RecipeParameterValue({
    Key? key,
    required this.parameterValue,
    required this.parameterType,
  }) : super(key: key);

  // can be int or double
  final dynamic parameterValue;
  final ParameterType parameterType;

  /// defines default values and whether grams is added to the end or not
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
      case ParameterType.noteTime:
        return (parameterValue ~/ 6).toString() +
            ":" +
            (parameterValue % 6).toString() +
            "0";
      case ParameterType.none:
        throw Exception("ParameterType.none passed incorrectly");
    }
  }

  /// defines text used for settings value display
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
      case ParameterType.noteTime:
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

/// all types of editable parameters for a recipe
/// eg. water amount, grind setting, notes time
enum ParameterType {
  noteTime,
  grindSetting,
  coffeeAmount,
  waterAmount,
  waterTemp,
  brewTime,
  none
}
