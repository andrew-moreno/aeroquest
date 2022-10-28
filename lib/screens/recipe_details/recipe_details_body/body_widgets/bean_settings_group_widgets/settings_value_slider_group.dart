import 'package:aeroquest/widgets/custom_modal_sheet/value_slider_group_template.dart';
import 'package:aeroquest/widgets/recipe_parameters_value.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:aeroquest/providers/recipes_provider.dart';
import 'package:aeroquest/models/recipe_settings.dart';

class SettingsValueSliderGroup extends StatefulWidget {
  const SettingsValueSliderGroup({
    Key? key,
    required this.maxWidth,
    this.recipeSettingsData,
  }) : super(key: key);

  final double maxWidth;
  final RecipeSettings? recipeSettingsData;

  @override
  State<SettingsValueSliderGroup> createState() =>
      _SettingsValueSliderGroupState();
}

class _SettingsValueSliderGroupState extends State<SettingsValueSliderGroup> {
  /// initializing setting values when modal sheet activated
  /// default values set when no values are passed (eg. adding new bean settings)
  @override
  void initState() {
    super.initState();
    Provider.of<RecipesProvider>(context, listen: false).tempGrindSetting =
        widget.recipeSettingsData?.grindSetting ?? 0;
    Provider.of<RecipesProvider>(context, listen: false).tempCoffeeAmount =
        widget.recipeSettingsData?.coffeeAmount ?? 0;
    Provider.of<RecipesProvider>(context, listen: false).tempWaterAmount =
        widget.recipeSettingsData?.waterAmount ?? 0;
    Provider.of<RecipesProvider>(context, listen: false).tempWaterTemp =
        widget.recipeSettingsData?.waterTemp ?? 100;
    Provider.of<RecipesProvider>(context, listen: false).tempBrewTime =
        widget.recipeSettingsData?.brewTime ?? 0;
    Provider.of<RecipesProvider>(context, listen: false).activeSlider =
        ParameterType.none;
  }

  @override
  Widget build(BuildContext context) {
    return ValueSliderGroupTemplate(
      maxWidth: widget.maxWidth,
      modalType: ModalType.settings,
    );
  }
}
