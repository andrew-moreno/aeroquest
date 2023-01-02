import 'package:aeroquest/models/recipe_step.dart';
import 'package:aeroquest/providers/recipes_provider.dart';
import 'package:aeroquest/providers/settings_slider_provider.dart';
import 'package:aeroquest/widgets/custom_modal_sheet/value_slider_group_template.dart';
import 'package:aeroquest/widgets/recipe_parameters_value.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipeStepsValueSlider extends StatefulWidget {
  /// Initializes the slider group for editing recipe steps specifically
  const RecipeStepsValueSlider({
    Key? key,
    required this.maxWidth,
    this.recipeStepsData,
  }) : super(key: key);

  /// Max width passed from the parent widget
  final double maxWidth;

  /// Recipe steps data to be edited
  final RecipeStep? recipeStepsData;

  @override
  State<RecipeStepsValueSlider> createState() => _RecipeStepsValueSliderState();
}

class _RecipeStepsValueSliderState extends State<RecipeStepsValueSlider> {
  /// Initializing recipe step values when modal sheet activated
  ///
  /// Default values set when no values are passed
  /// (adding new recipe steps)
  @override
  void initState() {
    super.initState();
    Provider.of<SettingsSliderProvider>(context, listen: false)
        .tempRecipeStepTime = widget.recipeStepsData?.time ?? 0;
    Provider.of<RecipesProvider>(context, listen: false).activeSlider =
        ParameterType.recipeStepTime;
  }

  @override
  Widget build(BuildContext context) {
    return ValueSliderGroupTemplate(
      maxWidth: widget.maxWidth,
      modalType: ModalType.recipeSteps,
    );
  }
}
