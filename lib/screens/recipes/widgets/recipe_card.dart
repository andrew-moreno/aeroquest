import 'package:aeroquest/providers/recipes_provider.dart';
import 'package:aeroquest/widgets/custom_card.dart';
import 'package:aeroquest/widgets/recipe_settings/recipe_settings_container.dart';
import 'package:flutter/material.dart';

import 'package:aeroquest/widgets/card_header.dart';
import 'package:aeroquest/models/recipe_settings.dart';
import 'package:aeroquest/models/recipe.dart';
import 'package:aeroquest/screens/recipe_details/recipe_details.dart';
import 'package:provider/provider.dart';

class RecipeCard extends StatelessWidget {
  /// Defines the widget for displaying individual recipes
  const RecipeCard({
    Key? key,
    required this.recipeData,
  }) : super(key: key);

  /// Recipe data to be displayed by the card
  final Recipe recipeData;

  @override
  Widget build(BuildContext context) {
    final Map<int, RecipeSettings> recipeSettings =
        Provider.of<RecipesProvider>(context, listen: false)
                .recipeSettings[recipeData.id] ??
            {};
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RecipeDetails(
              recipeData: recipeData,
              isAdding: false,
            ),
          ),
        );
      },
      child: CustomCard(
        child: Column(
          children: [
            CardHeader(
              title: recipeData.title,
              description: recipeData.description,
            ),
            Visibility(
              visible: recipeSettings.isNotEmpty,
              child: Column(
                children: (recipeSettings.values.any((recipeSetting) =>
                        RecipeSettings.stringToSettingVisibility(
                            recipeSetting.visibility) ==
                        SettingVisibility.shown))
                    ? [
                        const SizedBox(height: 10),
                        RecipeSettingsContainer(
                          recipeSettings: recipeSettings.values
                              .where((recipeSetting) =>
                                  RecipeSettings.stringToSettingVisibility(
                                      recipeSetting.visibility) ==
                                  SettingVisibility.shown)
                              .toList(),
                        )
                      ]
                    : [Container()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
