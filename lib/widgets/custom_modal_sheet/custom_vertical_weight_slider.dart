import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/providers/recipes_provider.dart';
import 'package:aeroquest/widgets/recipe_parameters_value.dart';
import 'package:flutter/material.dart';
import 'package:vertical_weight_slider/vertical_weight_slider.dart';

class CustomVerticalWeightSlider extends StatelessWidget {
  const CustomVerticalWeightSlider({
    Key? key,
    this.opacity = 1,
    this.disableScrolling = false,
    required this.maxWidth,
    required this.provider,
    required this.parameterType,
  }) : super(key: key);

  /// used to reduce opacity when slider is inactive
  final double opacity;

  /// if true, will set the sliders physics to NeverScrollableScrollPhysics
  final bool disableScrolling;

  /// max width of parent
  /// used to avoid clipping of the slider when modal is active
  final double maxWidth;

  /// provider passed down from parent
  final RecipesProvider provider;

  /// setting type to change for this slider
  final ParameterType parameterType;

  int _maxValue(ParameterType parameterType) {
    switch (parameterType) {
      case ParameterType.grindSetting:
        return 100;
      case ParameterType.coffeeAmount:
        return 100;
      case ParameterType.waterAmount:
        return 999;
      case ParameterType.waterTemp:
        return 100;
      case ParameterType.brewTime:
        return 180; // 30 minutes
      case ParameterType.noteTime:
        return 180;
      case ParameterType.none:

        /// value doesnt matter but initial value of slider set to 50
        /// must be greater than 50 plus space on screen
        return 100;
    }
  }

  @override
  Widget build(BuildContext context) {
    // initializing controllers for weight slider
    WeightSliderController _controllerSelector(ParameterType sliderType) {
      switch (sliderType) {
        case ParameterType.grindSetting:
          return WeightSliderController(
            initialWeight: provider.tempGrindSetting!,
            interval: 0.25,
          );
        case ParameterType.coffeeAmount:
          return WeightSliderController(
            initialWeight: provider.tempCoffeeAmount!.toDouble(),
            interval: 0.1,
          );
        case ParameterType.waterAmount:
          return WeightSliderController(
            initialWeight: provider.tempWaterAmount!.toDouble(),
            interval: 1,
          );
        case ParameterType.waterTemp:
          return WeightSliderController(
            initialWeight: provider.tempWaterTemp!.toDouble(),
            interval: 1,
          );
        case ParameterType.brewTime:
          return WeightSliderController(
            initialWeight: provider.tempBrewTime!.toDouble(),
            interval: 1,
          );
        case ParameterType.noteTime:
          return WeightSliderController(
              initialWeight: provider.tempNoteTime!.toDouble(), interval: 1);
        case ParameterType.none:
          return WeightSliderController(initialWeight: 50);
        default:
          throw Exception("_controllerSelector received incorrect parameters");
      }
    }

    return Visibility(
      visible: provider.activeSlider == parameterType ? true : false,
      child: Opacity(
        opacity: opacity,
        child: VerticalWeightSlider(
          disableScrolling: disableScrolling,
          maxWidth: maxWidth,
          maxWeight: _maxValue(parameterType),
          height: 40,
          decoration: const PointerDecoration(
            width: 25.0,
            height: 3.0,
            largeColor: kLightSecondary,
            mediumColor: kLightSecondary,
            gap: 0,
          ),
          controller: _controllerSelector(parameterType),
          onChanged: (double value) {
            provider.sliderOnChanged(value, parameterType);
          },
        ),
      ),
    );
  }
}
