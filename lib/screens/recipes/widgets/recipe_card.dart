import 'package:aeroquest/providers/recipes_provider.dart';
import 'package:aeroquest/widgets/recipe_settings/recipe_settings_container.dart';
import 'package:flutter/material.dart';

import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/widgets/card_header.dart';
import 'package:aeroquest/models/recipe_settings.dart';
import 'package:aeroquest/models/recipe.dart';
import 'package:aeroquest/screens/recipe_details/recipe_details.dart';
import 'package:provider/provider.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({
    Key? key,
    required this.recipeData,
  }) : super(key: key);

  final Recipe recipeData;

  @override
  Widget build(BuildContext context) {
    final List<RecipeSettings> recipeSettings =
        Provider.of<RecipesProvider>(context, listen: false)
                .recipeSettings[recipeData.id] ??
            [];
    return GestureDetector(
      onTap: () {
        Provider.of<RecipesProvider>(context, listen: false)
            .setTempRecipeSettings(recipeData.id!);
        Provider.of<RecipesProvider>(context, listen: false)
            .setTempRecipe(recipeData.id!);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RecipeDetails(
              recipeData: recipeData,
              showDeleteButton: true,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: kRecipeSettingsVerticalPadding,
          horizontal: 15,
        ),
        decoration: BoxDecoration(
          color: kPrimary,
          borderRadius: BorderRadius.circular(kCornerRadius),
          boxShadow: [kBoxShadow],
        ),
        child: Column(
          children: [
            CardHeader(
              title: recipeData.title,
              description: recipeData.description,
            ),
            Visibility(
              visible: recipeSettings.isNotEmpty,
              child: Column(
                children: [
                  const Divider(
                    color: Color(0x00000000),
                    height: 10,
                  ),
                  (recipeSettings.any((recipeSetting) =>
                          RecipeSettings.stringToSettingVisibility(
                              recipeSetting.visibility) ==
                          SettingVisibility.shown))
                      ? RecipeSettingsContainer(
                          recipeSettings: recipeSettings
                              .where((recipeSetting) =>
                                  RecipeSettings.stringToSettingVisibility(
                                      recipeSetting.visibility) ==
                                  SettingVisibility.shown)
                              .toList(),
                        )
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
