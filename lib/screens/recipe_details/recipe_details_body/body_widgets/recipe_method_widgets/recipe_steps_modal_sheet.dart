import 'package:aeroquest/models/recipe_step.dart';
import 'package:aeroquest/providers/recipes_provider.dart';
import 'package:aeroquest/providers/variables_slider_provider.dart';
import 'package:aeroquest/screens/recipe_details/recipe_details_body/body_widgets/recipe_method_widgets/recipe_steps_value_slider_group.dart';
import 'package:aeroquest/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';

import 'package:aeroquest/widgets/custom_button.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class RecipeStepsModalSheet extends StatefulWidget {
  /// Defines the modal sheet used for editing recipe variables
  const RecipeStepsModalSheet({
    Key? key,
    required this.submitAction,
    this.deleteAction,
    this.recipeStepsData,
  }) : super(key: key);

  /// Function to execute when submitting the modal sheet
  final Function() submitAction;

  /// Function to execute when pressing the delete button on the modal sheet
  final Function()? deleteAction;

  /// Recipe steps data being passed
  final RecipeStep? recipeStepsData;

  @override
  State<RecipeStepsModalSheet> createState() => _RecipeStepsModalSheetState();
}

class _RecipeStepsModalSheetState extends State<RecipeStepsModalSheet> {
  late final RecipesProvider _recipesProvider;
  late final VariablesSliderProvider _variablesSliderProvider;

  @override
  void initState() {
    super.initState();

    /// Used to initialize providers for use in [dispose] method
    _recipesProvider = Provider.of<RecipesProvider>(context, listen: false);
    _variablesSliderProvider =
        Provider.of<VariablesSliderProvider>(context, listen: false);
  }

  @override
  void dispose() {
    _recipesProvider.clearTempRecipeStepParameters();
    _variablesSliderProvider.clearTempRecipeStepParameters();
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
              RecipeStepsValueSlider(
                maxWidth: constraints.maxWidth,
                recipeStepsData: widget.recipeStepsData,
              ),
              const SizedBox(height: 20),
              FormBuilder(
                key: Provider.of<RecipesProvider>(context, listen: false)
                    .recipeRecipeStepsFormKey,
                child: CustomFormField(
                  formName: "recipeStepText",
                  hint: "Step",
                  initialValue: widget.recipeStepsData?.text,
                  validate: true,
                  validateText: "Please enter a recipeStep",
                  textCapitalization: TextCapitalization.sentences,
                ),
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
