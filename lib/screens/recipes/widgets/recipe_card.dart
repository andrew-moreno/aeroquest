import 'package:aeroquest/providers/recipes_provider.dart';
import 'package:aeroquest/widgets/custom_card.dart';
import 'package:aeroquest/widgets/recipe_variables/recipe_variables_container.dart';
import 'package:flutter/material.dart';

import 'package:aeroquest/widgets/card_header.dart';
import 'package:aeroquest/models/recipe_variables.dart';
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
    final Map<int, RecipeVariables> recipeVariables =
        Provider.of<RecipesProvider>(context, listen: false)
                .recipeVariables[recipeData.id] ??
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
              visible: recipeVariables.isNotEmpty,
              child: Column(
                children: (recipeVariables.values.any((recipeVariable) =>
                        RecipeVariables.stringToVariablesVisibility(
                            recipeVariable.visibility) ==
                        VariablesVisibility.shown))
                    ? [
                        const SizedBox(height: 10),
                        RecipeVariablesContainer(
                          recipeVariables: recipeVariables.values
                              .where((recipeVariable) =>
                                  RecipeVariables.stringToVariablesVisibility(
                                      recipeVariable.visibility) ==
                                  VariablesVisibility.shown)
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
