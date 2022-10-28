import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/providers/recipes_provider.dart';
import 'package:aeroquest/widgets/recipe_parameters_value.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ModalSliderValueContainer extends StatelessWidget {
  const ModalSliderValueContainer({
    Key? key,
    required this.parameterType,
    required this.provider,
  }) : super(key: key);

  /// defines the setting type of the settings value container
  /// (grind setting, coffee amount, etc.)
  final ParameterType parameterType;

  /// provider passed down from parent
  /// required for on tap activate/deactivate function to work
  final RecipesProvider provider;

  @override
  Widget build(BuildContext context) {
    dynamic _settingValue(ParameterType parameterType) {
      switch (parameterType) {
        case ParameterType.grindSetting:
          return Provider.of<RecipesProvider>(context).tempGrindSetting;
        case ParameterType.coffeeAmount:
          return Provider.of<RecipesProvider>(context).tempCoffeeAmount;
        case ParameterType.waterAmount:
          return Provider.of<RecipesProvider>(context).tempWaterAmount;
        case ParameterType.waterTemp:
          return Provider.of<RecipesProvider>(context).tempWaterTemp;
        case ParameterType.brewTime:
          return Provider.of<RecipesProvider>(context).tempBrewTime;
        case ParameterType.noteTime:
          return Provider.of<RecipesProvider>(context).tempNoteTime;
        case ParameterType.none:
          throw Exception("SettingType.none passed incorrectly");
      }
    }

    return GestureDetector(
      onTap: () {
        provider.selectSliderType(parameterType);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 7),
        margin: provider.activeSlider != parameterType
            ? const EdgeInsets.all(2)
            : null,
        decoration: BoxDecoration(
          color: kLightSecondary,
          borderRadius: BorderRadius.circular(kCornerRadius),
          boxShadow: [kBoxShadow],
          border: provider.activeSlider == parameterType
              ? Border.all(color: kAccent, width: 2)
              : null,
        ),
        child: RecipeParameterValue(
          parameterValue: _settingValue(parameterType),
          parameterType: parameterType,
        ),
      ),
    );
  }
}
