import 'package:aeroquest/providers/app_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:aeroquest/constraints.dart';
import 'package:provider/provider.dart';

class RecipeParameterValue extends StatefulWidget {
  /// Defines the widget for displaying recipe variable values
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

  @override
  State<RecipeParameterValue> createState() => _RecipeParameterValueState();
}

class _RecipeParameterValueState extends State<RecipeParameterValue> {
  /// Generates the string representation of the parameter value based on
  /// the [parameterType]
  String _parameterValue(ParameterType parameterType) {
    switch (parameterType) {
      case ParameterType.grindSetting:
        {
          int decimalPlaces;
          double grindInterval =
              Provider.of<AppSettingsProvider>(context, listen: false)
                  .grindInterval!;
          if (grindInterval == 1.0 || widget.parameterValue == 100) {
            decimalPlaces = 0;
          } else if (grindInterval == 0.25 || grindInterval == 1 / 3) {
            decimalPlaces = 2;
          } else {
            decimalPlaces = 1;
          }

          return widget.parameterValue.toStringAsFixed(decimalPlaces);
        }
      case ParameterType.coffeeAmount:
        return (widget.parameterValue)
            .toStringAsFixed((widget.parameterValue == 100) ? 0 : 1);
      case ParameterType.waterAmount:
        {
          int fractionDigits;
          MassUnit massUnit =
              Provider.of<AppSettingsProvider>(context, listen: false)
                  .massUnit!;
          if (massUnit == MassUnit.gram) {
            fractionDigits = 0;
          } else {
            fractionDigits = 1;
          }
          return (widget.parameterValue).toStringAsFixed(fractionDigits);
        }
      case ParameterType.waterTemp:
        {
          TemperatureUnit unitSystem =
              Provider.of<AppSettingsProvider>(context, listen: false)
                  .temperatureUnit!;
          if (unitSystem == TemperatureUnit.celsius) {
            return widget.parameterValue.toStringAsFixed(0);
          } else {
            num fahrenheit = (widget.parameterValue * 9 / 5) + 32;
            return fahrenheit.toStringAsFixed(0);
          }
        }
      case ParameterType.brewTime:
        return (widget.parameterValue ~/ 6).toString() +
            ":" +
            (widget.parameterValue % 6).toString() +
            "0";
      case ParameterType.recipeStepTime:
        return (widget.parameterValue ~/ 6).toString() +
            ":" +
            (widget.parameterValue % 6).toString() +
            "0";
      case ParameterType.none:
        return widget.parameterValue.toString();
    }
  }

  /// Converts the enum passed to [parameterType] to a string
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
        return "";
    }
  }

  /// Selects the correct unit to display next to recipe variable values
  String _unitType(ParameterType parameterType) {
    switch (parameterType) {
      case ParameterType.grindSetting:
        return "";
      case ParameterType.coffeeAmount:
      case ParameterType.waterAmount:
        {
          String units;
          MassUnit massUnit =
              Provider.of<AppSettingsProvider>(context, listen: false)
                  .massUnit!;
          if (massUnit == MassUnit.gram) {
            units = "g";
          } else {
            units = "oz";
          }
          return units;
        }
      case ParameterType.waterTemp:
        {
          String units;
          TemperatureUnit unitSystem =
              Provider.of<AppSettingsProvider>(context, listen: false)
                  .temperatureUnit!;
          if (unitSystem == TemperatureUnit.celsius) {
            units = "°C";
          } else {
            units = "°F";
          }
          return units;
        }
      case ParameterType.brewTime:
      case ParameterType.recipeStepTime:
      case ParameterType.none:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _parameterValue(widget.parameterType),
              style: Theme.of(context).textTheme.bodyText1!.copyWith(height: 0),
            ),
            Text(
              _unitType(widget.parameterType),
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(color: kAccentTransparent, height: 1.75),
            ),
          ],
        ),
        (widget.parameterType != ParameterType.none)
            ? Text(
                _parameterType(widget.parameterType),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(color: kAccentTransparent),
              )
            : Container(),
      ],
    );
  }
}

/// Defines all types of editable parameters for a recipe
///
/// eg. water amount, grind setting, recipe step time
enum ParameterType {
  grindSetting,
  coffeeAmount,
  waterAmount,
  waterTemp,
  brewTime,
  recipeStepTime,
  none
}
