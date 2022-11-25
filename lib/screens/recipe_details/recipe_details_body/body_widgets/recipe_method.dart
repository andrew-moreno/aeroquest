import 'package:aeroquest/providers/recipes_provider.dart';
import 'package:aeroquest/screens/recipe_details/recipe_details_body/recipe_details_body.dart';
import 'package:aeroquest/widgets/add_to_recipe_button.dart';
import 'package:aeroquest/widgets/animated_toggle.dart';
import 'package:aeroquest/widgets/custom_modal_sheet/value_slider_group_template.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:aeroquest/models/recipe.dart';
import 'package:aeroquest/models/note.dart';
import 'package:aeroquest/constraints.dart';
import 'package:provider/provider.dart';

class RecipeMethod extends StatefulWidget {
  /// Defines the widget for displaying push pressure, brew method, and notes
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
  /// Padding to use between method elements
  static const double _methodPadding = 15;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Consumer<RecipesProvider>(
        builder: (_, recipesProvider, __) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RecipeMethodParameters(
                    methodParameter: "Push Pressure",
                    methodParameterValue:
                        describeEnum(recipesProvider.tempPushPressure),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  RecipeMethodParameters(
                    methodParameter: "Brew Method",
                    methodParameterValue:
                        describeEnum(recipesProvider.tempBrewMethod),
                  ),
                ],
              ),
              const SizedBox(height: _methodPadding),
              ListView.separated(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: recipesProvider.tempNotes.length,
                itemBuilder: (BuildContext context, int index) {
                  int key = recipesProvider.tempNotes.keys.elementAt(index);
                  return RecipeMethodNotes(
                      note: recipesProvider.tempNotes[key]!);
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: _methodPadding);
                },
              ),
              const SizedBox(height: 20),
              (recipesProvider.editMode == EditMode.enabled)
                  ? AddToRecipeButton(
                      onTap: () {
                        showCustomModalSheet(
                            modalType: ModalType.notes,
                            submitAction: () {
                              if (!Provider.of<RecipesProvider>(context,
                                      listen: false)
                                  .recipeNotesFormKey
                                  .currentState!
                                  .validate()) {
                                return;
                              }
                              recipesProvider.tempAddNote(widget
                                  .recipeEntryId); // index doesn't matter for recipe entry id
                              Navigator.of(context).pop();
                            },
                            context: _);
                      },
                      buttonText: "Add Note")
                  : Container(),
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
        initialPosition: (Provider.of<RecipesProvider>(context, listen: false)
                    .tempBrewMethod ==
                BrewMethod.regular)
            ? Position.first
            : Position.last,
        toggleType: ToggleType.vertical,
      );
    } else if (methodParameterValue == describeEnum(PushPressure.light) ||
        methodParameter == describeEnum(PushPressure.heavy)) {
      return AnimatedToggle(
        values: _pushPressureToggleValues,
        onToggleCallback: (index) {
          index == 0
              ? Provider.of<RecipesProvider>(context, listen: false)
                  .tempPushPressure = PushPressure.light
              : Provider.of<RecipesProvider>(context, listen: false)
                  .tempPushPressure = PushPressure.heavy;
        },
        initialPosition: (Provider.of<RecipesProvider>(context, listen: false)
                    .tempPushPressure ==
                PushPressure.light)
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

class RecipeMethodNotes extends StatelessWidget {
  /// Defines the widget to display a single note for a recipe
  const RecipeMethodNotes({
    Key? key,
    required this.note,
  }) : super(key: key);

  /// Note data to display
  final Note note;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        var recipesProvider =
            Provider.of<RecipesProvider>(context, listen: false);
        if (recipesProvider.editMode == EditMode.enabled) {
          showCustomModalSheet(
              modalType: ModalType.notes,
              submitAction: () {
                recipesProvider.editNote(note);
                Navigator.of(context).pop();
              },
              deleteAction: () {
                recipesProvider.tempDeleteNote(note.id!);
                Navigator.of(context).pop();
              },
              notesData: note,
              context: context);
        }
      },
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
              Text(
                (note.time ~/ 6).toString() +
                    ":" +
                    (note.time % 6).toString() +
                    "0",
                style: const TextStyle(
                  color: kPrimary,
                  fontSize: 17,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  note.text,
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
