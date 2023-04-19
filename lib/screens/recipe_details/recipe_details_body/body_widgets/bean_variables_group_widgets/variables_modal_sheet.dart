import 'package:aeroquest/providers/variables_slider_provider.dart';
import 'package:aeroquest/screens/recipe_details/recipe_details_body/body_widgets/bean_variables_group_widgets/coffee_bean_dropdown.dart';
import 'package:aeroquest/widgets/animated_toggle.dart';
import 'package:aeroquest/providers/recipes_provider.dart';
import 'package:aeroquest/screens/recipe_details/recipe_details_body/body_widgets/bean_variables_group_widgets/variables_value_slider_group.dart';
import 'package:aeroquest/widgets/custom_button.dart';
import 'package:aeroquest/models/recipe_variables.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VariablesModalSheet extends StatefulWidget {
  /// Defines the modal sheet used for editing recipe variables
  const VariablesModalSheet({
    Key? key,
    required this.submitAction,
    this.deleteAction,
    this.recipeVariablesData,
  }) : super(key: key);

  /// Function to execute when submitting the modal sheet
  final Function() submitAction;

  /// Function to execute when pressing the delete button on the modal sheet
  final Function()? deleteAction;

  /// Recipe variables data being passed
  final RecipeVariables? recipeVariablesData;

  @override
  State<VariablesModalSheet> createState() => _VariablesModalSheetState();
}

class _VariablesModalSheetState extends State<VariablesModalSheet> {
  /// Options used for the animated toggle responsible for showing and hiding
  /// recipe variables
  final List<String> _animatedToggleValues = const ["Show", "Hide"];

  late final RecipesProvider _recipesProvider;
  late final VariablesSliderProvider _variablesSliderProvider;

  @override
  void initState() {
    super.initState();

    /// Used to initialize providers for use in [dispose] method
    _recipesProvider = Provider.of<RecipesProvider>(context, listen: false);
    _variablesSliderProvider =
        Provider.of<VariablesSliderProvider>(context, listen: false);

    Provider.of<RecipesProvider>(context, listen: false)
            .tempvariablesVisibility =
        (widget.recipeVariablesData?.visibility == null)
            ? VariablesVisibility.shown
            : RecipeVariables.stringToVariablesVisibility(
                widget.recipeVariablesData!.visibility);
    Provider.of<RecipesProvider>(context, listen: false).tempBeanId =
        widget.recipeVariablesData?.beanId;
  }

  @override
  void dispose() {
    _recipesProvider.clearTempVariablesParameters();
    _variablesSliderProvider.clearTempVariableParameters();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Show/Hide animated toggle
              AnimatedToggle(
                values: _animatedToggleValues,
                onToggleCallback: (index) {
                  index == 0
                      ? Provider.of<RecipesProvider>(context, listen: false)
                          .tempvariablesVisibility = VariablesVisibility.shown
                      : Provider.of<RecipesProvider>(context, listen: false)
                          .tempvariablesVisibility = VariablesVisibility.hidden;
                },
                initialPosition:
                    (Provider.of<RecipesProvider>(context, listen: false)
                                .tempvariablesVisibility ==
                            VariablesVisibility.shown)
                        ? Position.first
                        : Position.last,
                toggleType: ToggleType.horizontal,
              ),
              const SizedBox(height: 20),
              CoffeeBeanDropdown(
                recipeVariablesData: widget.recipeVariablesData,
              ),
              // Spacing handled in CoffeeBeanDropdown
              VariablesValueSliderGroup(
                maxWidth: constraints.maxWidth,
                recipeVariablesData: widget.recipeVariablesData,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: (widget.deleteAction != null)
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.center,
                children: [
                  CustomButton(
                    onTap: widget.submitAction,
                    buttonType: ButtonType.vibrant,
                    text: "Save",
                    width: constraints.maxWidth / 2 - 10,
                  ),
                  (widget.deleteAction != null)
                      ? CustomButton(
                          onTap: widget.deleteAction!,
                          buttonType: ButtonType.normal,
                          text: "Delete",
                          width: constraints.maxWidth / 2 - 10,
                        )
                      : Container(),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
