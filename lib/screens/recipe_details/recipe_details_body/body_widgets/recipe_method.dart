import 'package:aeroquest/providers/recipes_provider.dart';
import 'package:aeroquest/screens/recipe_details/recipe_details_body/recipe_details_body.dart';
import 'package:aeroquest/widgets/add_to_recipe_button.dart';
import 'package:aeroquest/widgets/animated_vertical_toggle.dart';
import 'package:aeroquest/widgets/custom_modal_sheet/value_slider_group_template.dart';
import 'package:flutter/material.dart';

import 'package:aeroquest/models/recipe.dart';
import 'package:aeroquest/models/note.dart';
import 'package:aeroquest/constraints.dart';
import 'package:provider/provider.dart';

class RecipeMethod extends StatefulWidget {
  const RecipeMethod({
    Key? key,
    required this.recipeEntryId,
  }) : super(key: key);

  final int recipeEntryId;
  static const double _methodPadding = 15;

  @override
  State<RecipeMethod> createState() => _RecipeMethodState();
}

class _RecipeMethodState extends State<RecipeMethod> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Consumer<RecipesProvider>(
        builder: (_, recipesProvider, ___) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RecipeMethodParameters(
                    description: "Push Pressure",
                    data: recipesProvider.tempPushPressure,
                  ),
                  const VerticalDivider(
                    color: Color(0x00000000),
                    thickness: 10,
                  ),
                  RecipeMethodParameters(
                    description: "Brew Method",
                    data: recipesProvider.tempBrewMethod,
                  ),
                ],
              ),
              const Divider(
                color: Color(0x00000000),
                height: RecipeMethod._methodPadding,
              ),
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
                  return const Divider(
                    color: Color(0x00000000),
                    height: RecipeMethod._methodPadding,
                  );
                },
              ),
              const Divider(
                color: Color(0x00000000),
                height: 20,
              ),
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

// template for push pressure and brew method text
class RecipeMethodParameters extends StatelessWidget {
  const RecipeMethodParameters({
    Key? key,
    required this.description,
    required this.data,
  }) : super(key: key);

  final String description;
  final dynamic data;

  String _enumTextConvert(dynamic action) {
    switch (action) {
      case PushPressure.light:
        return "Light";

      case PushPressure.heavy:
        return "Heavy";
      case BrewMethod.regular:
        return "Regular";
      case BrewMethod.inverted:
        return "Inverted";

      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> _pushPressureToggleValues = [
      _enumTextConvert(PushPressure.light),
      _enumTextConvert(PushPressure.heavy),
    ];
    List<String> _brewMethodToggleValues = [
      _enumTextConvert(BrewMethod.regular),
      _enumTextConvert(BrewMethod.inverted),
    ];

    Widget displayToggle(BuildContext context) {
      if (data.runtimeType == BrewMethod) {
        return AnimatedVerticalToggle(
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
              ? Position.top
              : Position.bottom,
        );
      } else {
        return AnimatedVerticalToggle(
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
              ? Position.top
              : Position.bottom,
        );
      }
    }

    return Column(
      children: [
        Text(
          description,
          style:
              Theme.of(context).textTheme.subtitle2!.copyWith(color: kSubtitle),
        ),
        (Provider.of<RecipesProvider>(context, listen: false).editMode ==
                EditMode.enabled)
            ? displayToggle(context)
            : Text(
                _enumTextConvert(data),
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
  const RecipeMethodNotes({Key? key, required this.note}) : super(key: key);

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
                recipesProvider.tempDeleteSetting(note.id!);
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
              const VerticalDivider(
                width: 20,
                color: Color(0x00000000),
              ),
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
