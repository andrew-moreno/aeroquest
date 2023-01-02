import 'package:aeroquest/models/recipe_note.dart';
import 'package:aeroquest/providers/recipes_provider.dart';
import 'package:aeroquest/providers/settings_slider_provider.dart';
import 'package:aeroquest/screens/recipe_details/recipe_details_body/recipe_details_body.dart';
import 'package:aeroquest/widgets/add_to_recipe_button.dart';
import 'package:aeroquest/widgets/custom_modal_sheet/value_slider_group_template.dart';
import 'package:flutter/material.dart';

import 'package:aeroquest/models/recipe.dart';
import 'package:aeroquest/constraints.dart';
import 'package:provider/provider.dart';

class RecipeNotes extends StatefulWidget {
  /// Defines the widget for displaying recipe notes
  const RecipeNotes({
    Key? key,
    required this.recipeEntryId,
  }) : super(key: key);

  /// Recipe that the method is associated with
  final int recipeEntryId;

  @override
  State<RecipeNotes> createState() => _RecipeNotesState();
}

class _RecipeNotesState extends State<RecipeNotes> {
  late Recipe _recipeData;

  late final RecipesProvider _recipesProvider =
      Provider.of<RecipesProvider>(context, listen: false);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _recipeData = _selectRecipeData();
  }

  Recipe _selectRecipeData() {
    if (_recipesProvider.editMode == EditMode.enabled) {
      return _recipesProvider.tempRecipe;
    } else {
      return _recipesProvider.recipes[widget.recipeEntryId]!;
    }
  }

  Map<int, RecipeNote> _selectRecipeNotesData() {
    if (_recipesProvider.editMode == EditMode.enabled) {
      return _recipesProvider.tempRecipeNotes;
    } else {
      return _recipesProvider.recipeNotes[widget.recipeEntryId] ?? {};
    }
  }

  /// Function to execute when pressing the "Add Note" button
  void addRecipeNote() {
    showCustomModalSheet(
      modalType: ModalType.notes,
      submitAction: () {
        if (!Provider.of<RecipesProvider>(context, listen: false)
            .recipeRecipeNotesFormKey
            .currentState!
            .validate()) {
          return;
        }
        _setRecipesProviderTempRecipeNoteParameters(context: context);
        _recipesProvider.tempAddRecipeNote(
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
          List<RecipeNote> _recipeNotesData =
              _selectRecipeNotesData().values.toList();
          return Column(
            children: [
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _recipeNotesData.length,
                itemBuilder: (BuildContext context, int index) {
                  return RecipeMethodRecipeNotes(
                      recipeNote: _recipeNotesData[
                          _recipeNotesData.length - index - 1]);
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: kRecipeDetailsVerticalPadding);
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: (recipesProvider.editMode == EditMode.enabled)
                    ? AddToRecipeButton(
                        onTap: addRecipeNote,
                        buttonText: "Add Note",
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

class RecipeMethodRecipeNotes extends StatefulWidget {
  /// Defines the widget to display a single recipeNote for a recipe
  const RecipeMethodRecipeNotes({
    Key? key,
    required this.recipeNote,
  }) : super(key: key);

  /// RecipeNote data to display
  final RecipeNote recipeNote;

  @override
  State<RecipeMethodRecipeNotes> createState() =>
      _RecipeMethodRecipeNotesState();
}

class _RecipeMethodRecipeNotesState extends State<RecipeMethodRecipeNotes> {
  late final _recipesProvider =
      Provider.of<RecipesProvider>(context, listen: false);

  void showEditingModal() {
    if (_recipesProvider.editMode == EditMode.enabled) {
      showCustomModalSheet(
          modalType: ModalType.notes,
          submitAction: () {
            if (!Provider.of<RecipesProvider>(context, listen: false)
                .recipeRecipeNotesFormKey
                .currentState!
                .validate()) {
              return;
            }
            _setRecipesProviderTempRecipeNoteParameters(context: context);
            _recipesProvider.editRecipeNote(widget.recipeNote);
            Navigator.of(context).pop();
          },
          deleteAction: () {
            _recipesProvider.tempDeleteRecipeNote(widget.recipeNote.id!);
            Navigator.of(context).pop();
          },
          recipeNotesData: widget.recipeNote,
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
          child: Text(
            widget.recipeNote.text,
            style: const TextStyle(
              color: kPrimary,
              fontSize: 13,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

/// Sets the temp recipeNote parameters from the SettingsSliderProvider to the
/// associated temp recipeNote parameter in the RecipeProvider
void _setRecipesProviderTempRecipeNoteParameters({
  required BuildContext context,
}) {
  Provider.of<RecipesProvider>(context, listen: false).tempRecipeNoteText =
      Provider.of<SettingsSliderProvider>(context, listen: false)
          .tempRecipeNoteText;
}
