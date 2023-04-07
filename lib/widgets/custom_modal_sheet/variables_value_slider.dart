import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/providers/app_settings_provider.dart';
import 'package:aeroquest/providers/recipes_provider.dart';
import 'package:aeroquest/providers/variables_slider_provider.dart';
import 'package:aeroquest/widgets/recipe_parameters_value.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vertical_weight_slider/vertical_weight_slider.dart';

class VariablesValueSlider extends StatefulWidget {
  /// Defines an individual value slider to be used when editing recipe
  /// variable values
  const VariablesValueSlider({
    Key? key,
    this.opacity = 1,
    this.disableScrolling = false,
    required this.maxWidth,
    required this.parameterType,
  }) : super(key: key);

  /// Opacity of the slider ticks
  ///
  /// Used for reducing the slider opacity when the slider is inactive
  final double opacity;

  /// Whether or not to disable scrolling for the slider
  ///
  /// If true, will set the sliders physics to NeverScrollableScrollPhysics
  final bool disableScrolling;

  /// Max width of parent widget
  ///
  /// Used to avoid clipping of the slider when modal is active
  final double maxWidth;

  /// Variable type to change for this slider
  final ParameterType parameterType;

  @override
  State<VariablesValueSlider> createState() => _VariablesValueSliderState();
}

class _VariablesValueSliderState extends State<VariablesValueSlider> {
  late final VariablesSliderProvider _variablesSliderProvider;

  @override
  void initState() {
    _variablesSliderProvider =
        Provider.of<VariablesSliderProvider>(context, listen: false);
    super.initState();
  }

  /// Max possible value for each slider type
  double _maxValue(ParameterType parameterType) {
    switch (parameterType) {
      case ParameterType.grindSetting:
        return 100;
      case ParameterType.coffeeAmount:
        {
          double maxValueInGrams = 50;
          CoffeeUnit coffeeUnit =
              Provider.of<AppSettingsProvider>(context, listen: false)
                  .coffeeUnit!;
          if (coffeeUnit == CoffeeUnit.gram) {
            return maxValueInGrams;
          } else if (coffeeUnit == CoffeeUnit.tbps) {
            /// grams to tbps conversion factor
            return maxValueInGrams / 5;
          } else {
            /// grams to scoops conversion factor
            return maxValueInGrams / 8.7;
          }
        }
      case ParameterType.waterAmount:
        {
          double maxValue;
          WaterUnit massUnit =
              Provider.of<AppSettingsProvider>(context, listen: false)
                  .waterUnit!;
          if (massUnit == WaterUnit.gram) {
            maxValue = 300;
          } else {
            maxValue = 300 / 28.34952;
          }
          return maxValue;
        }

      case ParameterType.waterTemp:
        {
          double maxValue;
          TemperatureUnit temperatureUnit =
              Provider.of<AppSettingsProvider>(context, listen: false)
                  .temperatureUnit!;
          if (temperatureUnit == TemperatureUnit.celsius) {
            maxValue = 100;
          } else {
            // Subtract 32 because idk why :(
            maxValue = 212 - 32;
          }
          return maxValue;
        }
      case ParameterType.brewTime:
        return 180; // 30 minutes
      case ParameterType.recipeStepTime:
        return 180;
      case ParameterType.none:

        /// value doesnt matter but initial value of slider set to 50
        /// must be greater than 50 plus space on screen
        return 100;
    }
  }

  // initializing controllers for weight slider
  WeightSliderController _controllerSelector(ParameterType sliderType) {
    switch (sliderType) {
      case ParameterType.grindSetting:
        return WeightSliderController(
          initialWeight: _variablesSliderProvider.tempGrindSetting!,
          interval: Provider.of<AppSettingsProvider>(context, listen: false)
              .grindInterval!,
        );
      case ParameterType.coffeeAmount:
        {
          double interval;
          CoffeeUnit coffeeUnit =
              Provider.of<AppSettingsProvider>(context, listen: false)
                  .coffeeUnit!;
          if (coffeeUnit == CoffeeUnit.gram) {
            interval = 1.0;
          } else {
            interval = 0.1;
          }
          return WeightSliderController(
            initialWeight: _variablesSliderProvider.tempCoffeeAmount!,
            interval: interval,
          );
        }

      case ParameterType.waterAmount:
        {
          double interval;
          WaterUnit unitSystem =
              Provider.of<AppSettingsProvider>(context, listen: false)
                  .waterUnit!;
          if (unitSystem == WaterUnit.gram) {
            interval = 1.0;
          } else {
            interval = 0.1;
          }
          return WeightSliderController(
            initialWeight: _variablesSliderProvider.tempWaterAmount!,
            interval: interval,
          );
        }
      case ParameterType.waterTemp:
        {
          double interval;
          TemperatureUnit temperatureUnit =
              Provider.of<AppSettingsProvider>(context, listen: false)
                  .temperatureUnit!;
          if (temperatureUnit == TemperatureUnit.celsius) {
            interval = 1.0;
          } else {
            interval = 5 / 9;
          }
          return WeightSliderController(
            initialWeight: _variablesSliderProvider.tempWaterTemp!,
            interval: interval,
          );
        }
      case ParameterType.brewTime:
        return WeightSliderController(
          initialWeight: _variablesSliderProvider.tempBrewTime!.toDouble(),
        );
      case ParameterType.recipeStepTime:
        return WeightSliderController(
          initialWeight:
              _variablesSliderProvider.tempRecipeStepTime!.toDouble(),
        );
      case ParameterType.none:
        return WeightSliderController(initialWeight: 50);
      default:
        throw Exception("_controllerSelector received incorrect parameters");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible:
          Provider.of<RecipesProvider>(context, listen: false).activeSlider ==
                  widget.parameterType
              ? true
              : false,
      child: Opacity(
        opacity: widget.opacity,
        child: VerticalWeightSlider(
          disableScrolling: widget.disableScrolling,
          maxWidth: widget.maxWidth,
          maxWeight: _maxValue(widget.parameterType),
          height: 40,
          decoration: const PointerDecoration(
            width: 25.0,
            height: 3.0,
            largeColor: kLightSecondary,
            mediumColor: kLightSecondary,
            gap: 0,
          ),
          controller: _controllerSelector(widget.parameterType),
          onChanged: (double value) {
            _variablesSliderProvider.sliderOnChanged(
                value, widget.parameterType);
          },
        ),
      ),
    );
  }
}
