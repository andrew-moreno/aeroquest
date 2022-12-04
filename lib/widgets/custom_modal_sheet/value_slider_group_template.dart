import 'package:aeroquest/widgets/custom_modal_sheet/modal_slider_value_container.dart';
import 'package:aeroquest/widgets/custom_modal_sheet/custom_vertical_weight_slider.dart';
import 'package:aeroquest/widgets/recipe_parameters_value.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:aeroquest/providers/recipes_provider.dart';

class ValueSliderGroupTemplate extends StatelessWidget {
  /// Defines the widget that contains all sliders and slider values
  ///
  /// Can be used for editing notes or recipe settings
  const ValueSliderGroupTemplate({
    Key? key,
    required this.maxWidth,
    required this.modalType,
  }) : super(key: key);

  /// Max width of parent widget
  final double maxWidth;

  /// Whether the modal sheet being displayed is used for editing recipe
  /// settings or notes
  final ModalType modalType;

  /// Returns a list of the appropriate parameter types based on [modalType]
  List<ParameterType> _parameterTypeListSelector() {
    if (modalType == ModalType.settings) {
      return [
        ParameterType.grindSetting,
        ParameterType.coffeeAmount,
        ParameterType.waterAmount,
        ParameterType.waterTemp,
        ParameterType.brewTime,
        ParameterType.none,
      ];
    } else {
      return [ParameterType.noteTime, ParameterType.none];
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

                /// notes modal cannot have an interactive value container
                /// see [isClickable]
                (modalType == ModalType.settings)
                    ? (index) => ModalSliderValueContainer(
                          parameterType: parameterType
                              .where((sliderType) =>
                                  sliderType != ParameterType.none)
                              .toList()[index],
                        )
                    : (index) => ModalSliderValueContainer(
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
                (index) => SettingValueSlider(
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
enum ModalType {
  settings,
  notes,
}
