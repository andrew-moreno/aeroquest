import 'package:aeroquest/models/recipe_note.dart';
import 'package:aeroquest/providers/recipes_provider.dart';
import 'package:aeroquest/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';

import 'package:aeroquest/widgets/custom_button.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class RecipeNotesModalSheet extends StatefulWidget {
  /// Defines the modal sheet used for editing recipe settings
  const RecipeNotesModalSheet({
    Key? key,
    required this.submitAction,
    this.deleteAction,
    this.recipeNotesData,
  }) : super(key: key);

  /// Function to execute when submitting the modal sheet
  final Function() submitAction;

  /// Function to execute when pressing the delete button on the modal sheet
  final Function()? deleteAction;

  /// Recipe notes data being passed
  final RecipeNote? recipeNotesData;

  @override
  State<RecipeNotesModalSheet> createState() => _RecipeNotesModalSheetState();
}

class _RecipeNotesModalSheetState extends State<RecipeNotesModalSheet> {
  late final RecipesProvider _recipesProvider;

  @override
  void initState() {
    super.initState();

    /// Used to initialize providers for use in [dispose] method
    _recipesProvider = Provider.of<RecipesProvider>(context, listen: false);
  }

  @override
  void dispose() {
    _recipesProvider.clearTempRecipeNoteParameters();
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
              FormBuilder(
                key: Provider.of<RecipesProvider>(context, listen: false)
                    .recipeRecipeNotesFormKey,
                child: CustomFormField(
                  autoFocus: true,
                  formName: "recipeNoteText",
                  hint: "Note",
                  initialValue: widget.recipeNotesData?.text,
                  validate: true,
                  validateText: "Please enter a note",
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
