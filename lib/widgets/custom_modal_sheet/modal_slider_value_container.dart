import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/providers/recipes_provider.dart';
import 'package:aeroquest/providers/settings_slider_provider.dart';
import 'package:aeroquest/widgets/recipe_parameters_value.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ModalSliderValueContainer extends StatefulWidget {
  /// Defines the widget used to display the recipe setting value inside
  /// the editing modal sheet
  const ModalSliderValueContainer({
    Key? key,
    required this.parameterType,
    this.isClickable = true,
  }) : super(key: key);

  /// Defines the setting type of the settings value container
  final ParameterType parameterType;

  /// Defines whether the container can be clicked or not
  ///
  /// Used to prevent deactivating the recipe steps time slider
  final bool isClickable;

  @override
  State<ModalSliderValueContainer> createState() =>
      _ModalSliderValueContainerState();
}

class _ModalSliderValueContainerState extends State<ModalSliderValueContainer> {
  /// Used for setting the appropriate setting value to the widget
  ///
  /// Values won't be null because they are set in [ValueSliderGroupTemplate]
  num _settingValue(ParameterType parameterType) {
    switch (parameterType) {
      case ParameterType.grindSetting:
        return Provider.of<SettingsSliderProvider>(context).tempGrindSetting!;
      case ParameterType.coffeeAmount:
        return Provider.of<SettingsSliderProvider>(context).tempCoffeeAmount!;
      case ParameterType.waterAmount:
        return Provider.of<SettingsSliderProvider>(context).tempWaterAmount!;
      case ParameterType.waterTemp:
        return Provider.of<SettingsSliderProvider>(context).tempWaterTemp!;
      case ParameterType.brewTime:
        return Provider.of<SettingsSliderProvider>(context).tempBrewTime!;
      case ParameterType.recipeStepTime:
        return Provider.of<SettingsSliderProvider>(context).tempRecipeStepTime!;
      case ParameterType.none:
        throw Exception("SettingType.none passed incorrectly");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.isClickable) {
          Provider.of<RecipesProvider>(context, listen: false)
              .selectSliderType(widget.parameterType);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(7),
        margin:
            Provider.of<RecipesProvider>(context, listen: false).activeSlider !=
                    widget.parameterType
                ? const EdgeInsets.all(2)
                : null,
        decoration: BoxDecoration(
          color: kLightSecondary,
          borderRadius: BorderRadius.circular(kCornerRadius),
          boxShadow: [kBoxShadow],
          border: Provider.of<RecipesProvider>(context, listen: false)
                      .activeSlider ==
                  widget.parameterType
              ? Border.all(color: kAccent, width: 2)
              : null,
        ),
        child: RecipeParameterValue(
          parameterValue: _settingValue(widget.parameterType),
          parameterType: widget.parameterType,
        ),
      ),
    );
  }
}
