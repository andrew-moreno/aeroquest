import 'dart:core';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:aeroquest/models/recipe_entry.dart';
import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/providers/recipes_provider.dart';
import 'package:aeroquest/screens/recipe_details/recipe_details_body/body_widgets/bean_settings_group_widgets/custom_settings_modal_sheet.dart';
import 'package:aeroquest/widgets/recipe_settings/widgets/bean_settings.dart';

class BeanSettingsGroup extends StatelessWidget {
  const BeanSettingsGroup({
    Key? key,
    required this.recipeData,
  }) : super(key: key);

  final RecipeEntry recipeData;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recipeData.coffeeSettings.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext buildContext, int index) {
        return Consumer<RecipesProvider>(builder: (_, recipes, child) {
          return GestureDetector(
            onTap: () {
              if (recipes.editMode == EditMode.enabled) {
                showCustomModalSheet(
                    submitAction: () {
                      Provider.of<RecipesProvider>(context, listen: false)
                          .editSetting(recipeData.coffeeSettings[index]);
                      Navigator.of(context).pop();
                    },
                    deleteAction: recipeData.coffeeSettings.length > 1
                        ? () {
                            Provider.of<RecipesProvider>(context, listen: false)
                                .deleteSetting(recipeData.id,
                                    recipeData.coffeeSettings[index].id);
                            Navigator.of(context).pop();
                          }
                        : null,
                    coffeeSettingsData: recipeData.coffeeSettings[index],
                    context: buildContext);
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
                coffeeSetting: recipeData.coffeeSettings[index],
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
  required Function() submitAction,
  required CoffeeSettings coffeeSettingsData,
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
        coffeeSettingsData: coffeeSettingsData,
      );
    },
  );
}
