import 'package:aeroquest/widgets/custom_modal_sheet/modal_slider_value.dart';
import 'package:aeroquest/widgets/custom_modal_sheet/variables_value_slider.dart';
import 'package:aeroquest/widgets/recipe_parameters_value.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:aeroquest/providers/recipes_provider.dart';

class ValueSliderGroupTemplate extends StatelessWidget {
  /// Defines the widget that contains all sliders and slider values
  ///
  /// Can be used for editing recipe steps or recipe variables
  const ValueSliderGroupTemplate({
    Key? key,
    required this.maxWidth,
    required this.modalType,
  }) : super(key: key);

  /// Max width of parent widget
  final double maxWidth;

  /// Whether the modal sheet being displayed is used for editing recipe
  /// variables or recipe steps
  final ModalType modalType;

  /// Returns a list of the appropriate parameter types based on [modalType]
  List<ParameterType> _parameterTypeListSelector() {
    if (modalType == ModalType.variables) {
      return [
        ParameterType.grindSetting,
        ParameterType.coffeeAmount,
        ParameterType.waterAmount,
        ParameterType.waterTemp,
        ParameterType.brewTime,
        ParameterType.none,
      ];
    } else {
      return [ParameterType.recipeStepTime, ParameterType.none];
    }
  }

  @override
  Widget build(BuildContext context) {
    List<ParameterType> parameterType = _parameterTypeListSelector();
    return Selector<RecipesProvider, ParameterType>(
      selector: (_, recipesProvider) => recipesProvider.activeSlider,
      builder: (_, activeSlider, __) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                // does not include Parameter.none
                parameterType.length - 1,

                /// recipe steps modal cannot have an interactive value container
                /// see [isClickable]
                (modalType == ModalType.variables)
                    ? (index) => ModalSliderValue(
                          parameterType: parameterType
                              .where((sliderType) =>
                                  sliderType != ParameterType.none)
                              .toList()[index],
                        )
                    : (index) => ModalSliderValue(
                          parameterType: parameterType
                              .where((sliderType) =>
                                  sliderType != ParameterType.none)
                              .toList()[index],
                          isClickable: false,
                        ),
              ),
            ),
            const SizedBox(height: 13),
            Stack(
              children: List.generate(
                // includes ParameterType.none
                parameterType.length,
                (index) => VariablesValueSlider(
                  maxWidth: maxWidth,
                  parameterType: parameterType[index],
                  disableScrolling: (parameterType[index] == ParameterType.none)
                      ? true
                      : false,
                  opacity:
                      (parameterType[index] == ParameterType.none) ? 0.3 : 1,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Describes the type of modal sheet to be displayed
enum ModalType { variables, steps, notes }
