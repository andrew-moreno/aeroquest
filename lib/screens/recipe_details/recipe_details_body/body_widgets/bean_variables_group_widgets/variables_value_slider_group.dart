import 'package:aeroquest/providers/recipes_provider.dart';
import 'package:aeroquest/providers/variables_slider_provider.dart';
import 'package:aeroquest/widgets/custom_modal_sheet/value_slider_group_template.dart';
import 'package:aeroquest/widgets/recipe_parameters_value.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:aeroquest/models/recipe_variables.dart';

class VariablesValueSliderGroup extends StatefulWidget {
  /// Initializes the slider group for editing recipe variables specifically
  const VariablesValueSliderGroup({
    Key? key,
    required this.maxWidth,
    this.recipeVariablesData,
  }) : super(key: key);

  /// Max width passed from the parent widget
  final double maxWidth;

  /// Recipe variables data to be edited
  final RecipeVariables? recipeVariablesData;

  @override
  State<VariablesValueSliderGroup> createState() =>
      _VariablesValueSliderGroupState();
}

class _VariablesValueSliderGroupState extends State<VariablesValueSliderGroup> {
  /// Initializing variables values when modal sheet activated
  ///
  /// Default values set when no values are passed
  /// (adding new bean variables)
  @override
  void initState() {
    super.initState();
    Provider.of<VariablesSliderProvider>(context, listen: false)
        .tempGrindSetting = widget.recipeVariablesData?.grindSetting ?? 0;
    Provider.of<VariablesSliderProvider>(context, listen: false)
        .tempCoffeeAmount = widget.recipeVariablesData?.coffeeAmount ?? 0;
    Provider.of<VariablesSliderProvider>(context, listen: false)
        .tempWaterAmount = widget.recipeVariablesData?.waterAmount ?? 0;
    Provider.of<VariablesSliderProvider>(context, listen: false).tempWaterTemp =
        widget.recipeVariablesData?.waterTemp ?? 100;
    Provider.of<VariablesSliderProvider>(context, listen: false).tempBrewTime =
        widget.recipeVariablesData?.brewTime ?? 0;
    Provider.of<RecipesProvider>(context, listen: false).activeSlider =
        ParameterType.none;
  }

  @override
  Widget build(BuildContext context) {
    return ValueSliderGroupTemplate(
      maxWidth: widget.maxWidth,
      modalType: ModalType.variables,
    );
  }
}
