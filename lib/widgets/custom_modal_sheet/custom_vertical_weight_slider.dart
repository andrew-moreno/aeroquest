import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/providers/app_settings_provider.dart';
import 'package:aeroquest/providers/recipes_provider.dart';
import 'package:aeroquest/providers/settings_slider_provider.dart';
import 'package:aeroquest/widgets/recipe_parameters_value.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vertical_weight_slider/vertical_weight_slider.dart';

class SettingValueSlider extends StatefulWidget {
  /// Defines an individual value slider to be used when editing recipe
  /// setting values
  const SettingValueSlider({
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

  /// Setting type to change for this slider
  final ParameterType parameterType;

  @override
  State<SettingValueSlider> createState() => _SettingValueSliderState();
}

class _SettingValueSliderState extends State<SettingValueSlider> {
  late final SettingsSliderProvider _settingsSliderProvider;

  @override
  void initState() {
    _settingsSliderProvider =
        Provider.of<SettingsSliderProvider>(context, listen: false);
    super.initState();
  }

  /// Max possible value for each slider type
  int _maxValue(ParameterType parameterType) {
    switch (parameterType) {
      case ParameterType.grindSetting:
        return 100;
      case ParameterType.coffeeAmount:
        return 100;
      case ParameterType.waterAmount:
        return 300; // roughly max amount of water possible in aeropress
      case ParameterType.waterTemp:
        return 100;
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
          initialWeight: _settingsSliderProvider.tempGrindSetting!,
          interval: Provider.of<AppSettingsProvider>(context, listen: false)
              .grindInterval!,
        );
      case ParameterType.coffeeAmount:
        return WeightSliderController(
          initialWeight: _settingsSliderProvider.tempCoffeeAmount!,
          interval: 0.1,
        );
      case ParameterType.waterAmount:
        return WeightSliderController(
          initialWeight: _settingsSliderProvider.tempWaterAmount!.toDouble(),
        );
      case ParameterType.waterTemp:
        return WeightSliderController(
          initialWeight: _settingsSliderProvider.tempWaterTemp!.toDouble(),
        );
      case ParameterType.brewTime:
        return WeightSliderController(
          initialWeight: _settingsSliderProvider.tempBrewTime!.toDouble(),
        );
      case ParameterType.recipeStepTime:
        return WeightSliderController(
          initialWeight: _settingsSliderProvider.tempRecipeStepTime!.toDouble(),
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
            _settingsSliderProvider.sliderOnChanged(
                value, widget.parameterType);
          },
        ),
      ),
    );
  }
}
