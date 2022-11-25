import 'package:aeroquest/models/note.dart';
import 'package:aeroquest/models/recipe_settings.dart';
import 'package:aeroquest/screens/recipe_details/recipe_details_body/body_widgets/bean_settings_group_widgets/settings_modal_sheet.dart';
import 'package:aeroquest/screens/recipe_details/recipe_details_body/body_widgets/recipe_method_widgets/notes_modal_sheet.dart';
import 'package:aeroquest/widgets/custom_modal_sheet/value_slider_group_template.dart';
import 'package:flutter/material.dart';

import 'package:aeroquest/screens/recipe_details/recipe_details_body/body_widgets/bean_settings_group.dart';
import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/screens/recipe_details/recipe_details_body/body_widgets/recipe_method.dart';

class RecipeDetailsBody extends StatefulWidget {
  /// Defines the widget that contains all information about a recipe
  /// excluding its title and description
  const RecipeDetailsBody({
    Key? key,
    required this.recipeId,
  }) : super(key: key);

  /// The recipe that is associated with this details page
  final int recipeId;

  @override
  State<RecipeDetailsBody> createState() => _RecipeDetailsBodyState();
}

class _RecipeDetailsBodyState extends State<RecipeDetailsBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kDarkSecondary,
      padding: const EdgeInsets.only(
        top: 20,
        left: 35,
        right: 35,
        bottom: 20,
      ),
      child: Column(
        children: [
          Text(
            "Bean Settings",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline4,
          ),
          const SizedBox(height: 15),
          BeanSettingsGroup(
            recipeEntryId: widget.recipeId,
          ),
          const SizedBox(height: 30),
          Text(
            "Method",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline4,
          ),
          const SizedBox(height: 15),
          RecipeMethod(
            recipeEntryId: widget.recipeId,
          ),
        ],
      ),
    );
  }
}

/// Used to show the modal sheet used for editing notes or recipe settings
void showCustomModalSheet({
  required BuildContext context,
  required Function() submitAction,
  Function()? deleteAction,
  required ModalType modalType,
  RecipeSettings? recipeSettingsData,
  Note? notesData,
}) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius:
          BorderRadius.vertical(top: Radius.circular(kModalCornerRadius)),
    ),
    backgroundColor: kDarkSecondary,
    isScrollControlled: true,
    builder: (_) {
      if (modalType == ModalType.settings) {
        return SettingsModalSheet(
          submitAction: submitAction,
          deleteAction: deleteAction,
          recipeSettingsData: recipeSettingsData,
        );
      } else {
        return NotesModalSheet(
          submitAction: submitAction,
          deleteAction: deleteAction,
          notesData: notesData,
        );
      }
    },
  );
}
