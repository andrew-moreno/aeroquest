import 'package:provider/provider.dart';
import 'dart:core';

import 'package:flutter/material.dart';

import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/screens/recipe_details/recipe_details_body/body_widgets/bean_settings_group_widgets/custom_settings_modal_sheet.dart';
import 'package:aeroquest/models/recipe_settings.dart';
import 'package:aeroquest/providers/recipes_provider.dart';
import 'package:aeroquest/widgets/recipe_settings/widgets/bean_settings.dart';
import 'package:aeroquest/models/recipe.dart';

class BeanSettingsGroup extends StatefulWidget {
  const BeanSettingsGroup({
    Key? key,
    required this.recipeData,
    required this.recipeSettingsData,
  }) : super(key: key);

  final Recipe recipeData;
  final List<RecipeSettings> recipeSettingsData;

  @override
  State<BeanSettingsGroup> createState() => _BeanSettingsGroupState();
}

class _BeanSettingsGroupState extends State<BeanSettingsGroup> {
  @override
  Widget build(BuildContext context) {
    return Consumer<RecipesProvider>(builder: (_, recipesProvider, ___) {
      return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.recipeSettingsData.length,
        shrinkWrap: true,
        itemBuilder: (_, int index) {
          return GestureDetector(
            onTap: () {
              if (recipesProvider.editMode == EditMode.enabled) {
                showCustomModalSheet(
                    submitAction: () {
                      recipesProvider
                          .editSetting(widget.recipeSettingsData[index]);
                      Navigator.of(context).pop();
                    },
                    deleteAction: widget.recipeSettingsData.length > 1
                        ? () {
                            recipesProvider.deleteSetting(
                                widget.recipeSettingsData[index].id!);
                            Navigator.of(context).pop();
                          }
                        : null,
                    recipeSettingsData: widget.recipeSettingsData[index],
                    context: _);
              }
            },
            child: Visibility(
              visible: (recipesProvider.editMode == EditMode.disabled &&
                      RecipeSettings.stringToSettingVisibility(
                              widget.recipeSettingsData[index].visibility) ==
                          SettingVisibility.hidden)
                  ? false
                  : true,
              child: Opacity(
                opacity: (recipesProvider.editMode == EditMode.enabled &&
                        RecipeSettings.stringToSettingVisibility(
                                widget.recipeSettingsData[index].visibility) ==
                            SettingVisibility.hidden)
                    ? 0.5
                    : 1,
                child: Container(
                  padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: kDarkSecondary,
                    borderRadius: BorderRadius.circular(kCornerRadius),
                    boxShadow: (recipesProvider.editMode == EditMode.enabled)
                        ? [kSettingsBoxShadow]
                        : [],
                  ),
                  child: BeanSettings(
                    recipeSetting: widget.recipeSettingsData[index],
                  ),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const Divider(
            color: Color(0x00000000),
            height: 10,
          );
        },
      );
    });
  }
}

void showCustomModalSheet({
  required BuildContext context,
  required Function() submitAction,
  required RecipeSettings recipeSettingsData,
  Function()? deleteAction,
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
        recipeSettingsData: recipeSettingsData,
      );
    },
  );
}
