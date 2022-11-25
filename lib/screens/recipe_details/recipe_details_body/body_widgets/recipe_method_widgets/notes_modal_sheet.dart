import 'package:aeroquest/models/note.dart';
import 'package:aeroquest/providers/recipes_provider.dart';
import 'package:aeroquest/screens/recipe_details/recipe_details_body/body_widgets/recipe_method_widgets/notes_value_slider_group.dart';
import 'package:aeroquest/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';

import 'package:aeroquest/widgets/custom_button.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class NotesModalSheet extends StatelessWidget {
  /// Defines the modal sheet used for editing recipe settings
  const NotesModalSheet({
    Key? key,
    required this.submitAction,
    this.deleteAction,
    this.notesData,
  }) : super(key: key);

  /// Function to execute when submitting the modal sheet
  final Function() submitAction;

  /// Function to execute when pressing the delete button on the modal sheet
  final Function()? deleteAction;

  /// Notes data being passed
  final Note? notesData;

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
              NotesValueSlider(
                maxWidth: constraints.maxWidth,
                notesData: notesData,
              ),
              const Divider(height: 20, color: Color(0x00000000)),
              FormBuilder(
                key: Provider.of<RecipesProvider>(context, listen: false)
                    .recipeNotesFormKey,
                child: CustomFormField(
                  formName: "noteText",
                  hint: "Note",
                  initialValue: notesData?.text,
                  validate: true,
                  validateText: "Please enter a note",
                ),
              ),
              const Divider(height: 20, color: Color(0x00000000)),
              Row(
                mainAxisAlignment: (deleteAction != null)
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.center,
                children: [
                  CustomButton(
                    onTap: submitAction,
                    buttonType: ButtonType.vibrant,
                    text: "Save",
                    width: constraints.maxWidth / 2 - 10,
                  ),
                  (deleteAction != null)
                      ? CustomButton(
                          onTap: deleteAction!,
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
