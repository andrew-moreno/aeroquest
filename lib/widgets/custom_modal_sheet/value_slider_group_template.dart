import 'package:aeroquest/widgets/custom_modal_sheet/modal_slider_value_container.dart';
import 'package:aeroquest/widgets/custom_modal_sheet/custom_vertical_weight_slider.dart';
import 'package:aeroquest/widgets/recipe_parameters_value.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:aeroquest/providers/recipes_provider.dart';

class ValueSliderGroupTemplate extends StatefulWidget {
  const ValueSliderGroupTemplate(
      {Key? key, required this.maxWidth, required this.modalType})
      : super(key: key);

  final double maxWidth;
  final ModalType modalType;

  @override
  State<ValueSliderGroupTemplate> createState() =>
      _ValueSliderGroupTemplateState();
}

class _ValueSliderGroupTemplateState extends State<ValueSliderGroupTemplate> {
  List<ParameterType> _parameterTypeListSelector() {
    if (widget.modalType == ModalType.settings) {
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
    return Consumer<RecipesProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                // does not include Parameter.none
                parameterType.length - 1,
                (index) => ModalSliderValueContainer(
                  parameterType: parameterType
                      .where((sliderType) => sliderType != ParameterType.none)
                      .toList()[index],
                  provider: provider,
                ),
              ),
            ),
            const Divider(height: 13, color: Color(0x00000000)),
            Stack(
              children: List.generate(
                // includes ParameterType.none
                parameterType.length,
                (index) => CustomVerticalWeightSlider(
                  maxWidth: widget.maxWidth,
                  provider: provider,
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

enum ModalType {
  settings,
  notes,
}
