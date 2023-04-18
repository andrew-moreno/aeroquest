import 'package:aeroquest/providers/recipes_provider.dart';
import 'package:aeroquest/providers/variables_slider_provider.dart';
import 'package:aeroquest/screens/recipe_details/recipe_details.dart';
import 'package:aeroquest/widgets/add_to_recipe_button.dart';
import 'package:aeroquest/widgets/animated_toggle.dart';
import 'package:aeroquest/widgets/custom_modal_sheet/value_slider_group_template.dart';
import 'package:aeroquest/widgets/empty_details_text.dart';
import 'package:aeroquest/models/recipe.dart';
import 'package:aeroquest/models/recipe_step.dart';
import 'package:aeroquest/constraints.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipeMethod extends StatefulWidget {
  /// Defines the widget for displaying push pressure, brew method, and
  /// recipe steps
  const RecipeMethod({
    Key? key,
    required this.recipeEntryId,
  }) : super(key: key);

  /// Recipe that the method is associated with
  final int recipeEntryId;

  @override
  State<RecipeMethod> createState() => _RecipeMethodState();
}

class _RecipeMethodState extends State<RecipeMethod> {
  late Recipe _recipeData;

  late final RecipesProvider _recipesProvider =
      Provider.of<RecipesProvider>(context, listen: false);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _recipeData = _selectRecipeData();
  }

  /// Returns either [tempRecipe] or [recipes] data depending on whether recipe
  /// is being edited or not
  Recipe _selectRecipeData() {
    if (_recipesProvider.editMode == EditMode.enabled) {
      return _recipesProvider.tempRecipe;
    } else {
      return _recipesProvider.recipes[widget.recipeEntryId]!;
    }
  }

  /// Returns either [tempRecipeSteps] or [recipeSteps] depending on whether
  /// recipe is being edited or not
  Map<int, RecipeStep> _selectRecipeStepsData() {
    if (_recipesProvider.editMode == EditMode.enabled) {
      return _recipesProvider.tempRecipeSteps;
    } else {
      return _recipesProvider.recipeSteps[widget.recipeEntryId] ?? {};
    }
  }

  /// Function to execute when pressing the "Add Step" button
  void addRecipeStep() {
    showCustomModalSheet(
      modalType: ModalType.steps,
      submitAction: () {
        if (!Provider.of<RecipesProvider>(context, listen: false)
            .recipeRecipeStepsFormKey
            .currentState!
            .validate()) {
          return;
        }
        _setRecipesProviderTempRecipeStepParameters(context: context);
        _recipesProvider.tempAddRecipeStep(
            widget.recipeEntryId); // index doesn't matter for recipe entry id
        Navigator.of(context).pop();
      },
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Consumer<RecipesProvider>(
        builder: (_, recipesProvider, __) {
          List<RecipeStep> _recipeStepsData =
              _selectRecipeStepsData().values.toList();
          _recipeStepsData.sort((a, b) => a.time.compareTo(b.time));
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RecipeMethodParameters(
                    methodParameter: "Push Pressure",
                    methodParameterValue: _recipeData.pushPressure,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  RecipeMethodParameters(
                    methodParameter: "Brew Method",
                    methodParameterValue: _recipeData.brewMethod,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              (_recipeStepsData.isNotEmpty)
                  ? ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _recipeStepsData.length,
                      itemBuilder: (BuildContext context, int index) {
                        return RecipeMethodRecipeSteps(
                            recipeStep: _recipeStepsData[index]);
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                            height: kRecipeDetailsVerticalPadding);
                      },
                    )
                  : const EmptyDetailsText(dataType: RecipeDetailsText.step),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: (recipesProvider.editMode == EditMode.enabled)
                    ? AddToRecipeButton(
                        onTap: addRecipeStep,
                        buttonText: "Add Step",
                      )
                    : Container(),
              ),
            ],
          );
        },
      ),
    );
  }
}

class RecipeMethodParameters extends StatelessWidget {
  /// Defines the widget used to display and edit push pressure and brew method
  RecipeMethodParameters({
    Key? key,
    required this.methodParameter,
    required this.methodParameterValue,
  }) : super(key: key);

  /// Text used to identify the method parameter
  ///
  /// Values passed are either Push Pressure or Brew Method
  final String methodParameter;

  /// Value of method parameter
  ///
  /// Passed as a lower cased string represetnation of either a PushPressure
  /// or BrewMethod type
  final String methodParameterValue;

  /// Capitalizes the first letter of a lower case string
  static String _capitalizeFirstLetter(String string) {
    return "${string[0].toUpperCase()}${string.substring(1)}";
  }

  /// Possible values that can be applied to the push pressure toggle
  final List<String> _pushPressureToggleValues = [
    _capitalizeFirstLetter(describeEnum(PushPressure.light)),
    _capitalizeFirstLetter(describeEnum(PushPressure.heavy)),
  ];

  /// Possible values that can be applied to the brew method toggle
  final List<String> _brewMethodToggleValues = [
    _capitalizeFirstLetter(describeEnum(BrewMethod.regular)),
    _capitalizeFirstLetter(describeEnum(BrewMethod.inverted)),
  ];

  /// Selects the appropriate toggle based on the type passed to
  /// [methodParameterValue]
  ///
  /// Throws an exception if [methodParameterValue] receives the wrong type
  Widget _displayToggle(BuildContext context) {
    if (methodParameterValue == describeEnum(BrewMethod.regular) ||
        methodParameterValue == describeEnum(BrewMethod.inverted)) {
      return AnimatedToggle(
        values: _brewMethodToggleValues,
        onToggleCallback: (index) {
          index == 0
              ? Provider.of<RecipesProvider>(context, listen: false)
                  .tempBrewMethod = BrewMethod.regular
              : Provider.of<RecipesProvider>(context, listen: false)
                  .tempBrewMethod = BrewMethod.inverted;
        },
        initialPosition:
            (methodParameterValue == describeEnum(BrewMethod.regular))
                ? Position.first
                : Position.last,
        toggleType: ToggleType.vertical,
      );
    } else if (methodParameterValue == describeEnum(PushPressure.light) ||
        methodParameterValue == describeEnum(PushPressure.heavy)) {
      return AnimatedToggle(
        values: _pushPressureToggleValues,
        onToggleCallback: (index) {
          index == 0
              ? Provider.of<RecipesProvider>(context, listen: false)
                  .tempPushPressure = PushPressure.light
              : Provider.of<RecipesProvider>(context, listen: false)
                  .tempPushPressure = PushPressure.heavy;
        },
        initialPosition:
            (methodParameterValue == describeEnum(PushPressure.light))
                ? Position.first
                : Position.last,
        toggleType: ToggleType.vertical,
      );
    } else {
      throw Exception("Incorrect type passed to methodParameterValue");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          methodParameter,
          style:
              Theme.of(context).textTheme.subtitle2!.copyWith(color: kSubtitle),
        ),
        (Provider.of<RecipesProvider>(context, listen: false).editMode ==
                EditMode.enabled)
            ? _displayToggle(context)
            : Text(
                _capitalizeFirstLetter(methodParameterValue),
                style: Theme.of(context)
                    .textTheme
                    .subtitle2!
                    .copyWith(color: kAccent),
              ),
      ],
    );
  }
}

class RecipeMethodRecipeSteps extends StatefulWidget {
  /// Defines the widget to display a single recipeStep for a recipe
  const RecipeMethodRecipeSteps({
    Key? key,
    required this.recipeStep,
  }) : super(key: key);

  /// RecipeStep data to display
  final RecipeStep recipeStep;

  @override
  State<RecipeMethodRecipeSteps> createState() =>
      _RecipeMethodRecipeStepsState();
}

class _RecipeMethodRecipeStepsState extends State<RecipeMethodRecipeSteps> {
  late final _recipesProvider =
      Provider.of<RecipesProvider>(context, listen: false);

  void showEditingModal() {
    if (_recipesProvider.editMode == EditMode.enabled) {
      showCustomModalSheet(
          modalType: ModalType.steps,
          submitAction: () {
            if (!Provider.of<RecipesProvider>(context, listen: false)
                .recipeRecipeStepsFormKey
                .currentState!
                .validate()) {
              return;
            }
            _setRecipesProviderTempRecipeStepParameters(context: context);
            _recipesProvider.editRecipeStep(widget.recipeStep);
            Navigator.of(context).pop();
          },
          deleteAction: () {
            _recipesProvider.tempDeleteRecipeStep(widget.recipeStep.id!);
            Navigator.of(context).pop();
          },
          recipeStepsData: widget.recipeStep,
          context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: showEditingModal,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        decoration: BoxDecoration(
          color: kLightSecondary,
          borderRadius: BorderRadius.circular(kCornerRadius),
        ),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 55,
                child: Text(
                  (widget.recipeStep.time ~/ 6).toString() +
                      ":" +
                      (widget.recipeStep.time % 6).toString() +
                      "0",
                  style: const TextStyle(
                    color: kPrimary,
                    fontSize: 17,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              //const SizedBox(width: 20),
              Expanded(
                child: Text(
                  widget.recipeStep.text,
                  style: const TextStyle(
                    color: kPrimary,
                    fontSize: 13,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Sets the temp recipeStep parameters from the VariablesSliderProvider to the
/// associated temp recipeStep parameter in the RecipeProvider
void _setRecipesProviderTempRecipeStepParameters({
  required BuildContext context,
}) {
  Provider.of<RecipesProvider>(context, listen: false).tempRecipeStepText =
      Provider.of<VariablesSliderProvider>(context, listen: false)
          .tempRecipeStepText;
  Provider.of<RecipesProvider>(context, listen: false).tempRecipeStepTime =
      Provider.of<VariablesSliderProvider>(context, listen: false)
          .tempRecipeStepTime;
}
