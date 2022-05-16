import 'package:aeroquest/widgets/animated_toggle.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:aeroquest/widgets/modal_button.dart';
import 'package:aeroquest/models/recipe_entry.dart';
import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/models/recipes_provider.dart';
import 'package:aeroquest/widgets/recipe_settings/widgets/bean_settings.dart';

class BeanSettingsGroup extends StatelessWidget {
  const BeanSettingsGroup({
    Key? key,
    required recipeData,
  })  : _recipeData = recipeData,
        super(key: key);

  final RecipeEntry _recipeData;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _recipeData.coffeeSettings.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext buildContext, int index) {
        return Consumer<RecipesProvider>(builder: (_, recipes, child) {
          return GestureDetector(
            onTap: () {
              if (recipes.editMode == EditMode.enabled) {
                showCustomModalSheet(
                    submitAction: () {}, context: buildContext);
              }
            },
            child: Container(
              padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
              width: double.infinity,
              decoration: BoxDecoration(
                color: kDarkSecondary,
                borderRadius: BorderRadius.circular(kCornerRadius),
                boxShadow: (recipes.editMode == EditMode.enabled)
                    ? [kSettingsBoxShadow]
                    : [],
              ),
              child: BeanSettings(
                coffeeSetting: _recipeData.coffeeSettings[index],
              ),
            ),
          );
        });
      },
      separatorBuilder: (context, index) {
        return const Divider(
          color: Color(0x00000000),
          height: 10,
        );
      },
    );
  }
}

void showCustomModalSheet({
  required BuildContext context,
  required Function submitAction,
  Function? deleteAction,
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
      return CustomSettingsModalSheet(
        submitAction: submitAction,
        deleteAction: deleteAction,
      );
    },
  );
}

class CustomSettingsModalSheet extends StatelessWidget {
  const CustomSettingsModalSheet(
      {Key? key, required submitAction, deleteAction})
      : _submitAction = submitAction,
        _deleteAction = deleteAction,
        super(key: key);

  final Function _submitAction;
  final Function? _deleteAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20),
      child: LayoutBuilder(builder: (context, constraints) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedToggle(
              values: const ["Show", "Hide"],
              onToggleCallback: (_) {},
              backgroundColor: kLightSecondary,
              buttonColor: kAccent,
              textColor: kDarkSecondary,
            ),
            const Divider(height: 20, color: Color(0x00000000)),
            Row(
              mainAxisAlignment: (_deleteAction != null)
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.center,
              children: [
                ModalButton(
                  onTap: _submitAction,
                  buttonType: ButtonType.positive,
                  text: "Save",
                  width: constraints.maxWidth / 2 - 10,
                ),
                (_deleteAction != null)
                    ? ModalButton(
                        onTap: _deleteAction,
                        buttonType: ButtonType.negative,
                        text: "Delete",
                        width: constraints.maxWidth / 2 - 10,
                      )
                    : Container(),
              ],
            ),
          ],
        );
      }),
    );
  }
}
