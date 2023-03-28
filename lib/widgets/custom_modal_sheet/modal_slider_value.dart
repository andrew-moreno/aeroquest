import 'package:aeroquest/providers/recipes_provider.dart';
import 'package:aeroquest/providers/variables_slider_provider.dart';
import 'package:aeroquest/widgets/custom_modal_sheet/modal_value_container.dart';
import 'package:aeroquest/widgets/recipe_parameters_value.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ModalSliderValue extends StatefulWidget {
  /// Defines the widget used to display the recipe variable container and value
  /// inside the editing modal sheet
  const ModalSliderValue({
    Key? key,
    required this.parameterType,
    this.isClickable = true,
  }) : super(key: key);

  /// Defines the variable type of the variables value container
  final ParameterType parameterType;

  /// Defines whether the container can be clicked or not
  ///
  /// Used to prevent deactivating the recipe steps time slider
  final bool isClickable;

  @override
  State<ModalSliderValue> createState() => _ModalSliderValueState();
}

class _ModalSliderValueState extends State<ModalSliderValue> {
  /// Used for setting the appropriate variable value to the widget
  ///
  /// Values won't be null because they are set in [ValueSliderGroupTemplate]
  num _variableValue(ParameterType parameterType) {
    switch (parameterType) {
      case ParameterType.grindSetting:
        return Provider.of<VariablesSliderProvider>(context).tempGrindSetting!;
      case ParameterType.coffeeAmount:
        return Provider.of<VariablesSliderProvider>(context).tempCoffeeAmount!;
      case ParameterType.waterAmount:
        return Provider.of<VariablesSliderProvider>(context).tempWaterAmount!;
      case ParameterType.waterTemp:
        return Provider.of<VariablesSliderProvider>(context).tempWaterTemp!;
      case ParameterType.brewTime:
        return Provider.of<VariablesSliderProvider>(context).tempBrewTime!;
      case ParameterType.recipeStepTime:
        return Provider.of<VariablesSliderProvider>(context)
            .tempRecipeStepTime!;
      case ParameterType.none:
        throw Exception("VariableType.none passed incorrectly");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalValueContainer(
      child: Padding(
        padding: const EdgeInsets.all(7.0),
        child: RecipeParameterValue(
          parameterValue: _variableValue(widget.parameterType),
          parameterType: widget.parameterType,
        ),
      ),
      onTap: () {
        if (widget.isClickable) {
          Provider.of<RecipesProvider>(context, listen: false)
              .selectSliderType(widget.parameterType);
        }
      },
      displayBorder:
          Provider.of<RecipesProvider>(context, listen: false).activeSlider ==
              widget.parameterType,
    );
  }
}
