import 'package:flutter/material.dart';

import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/models/recipe_entry.dart';
import 'package:aeroquest/screens/recipe_details/recipe_details.dart';
import 'package:aeroquest/widgets/card_header.dart';
import 'package:aeroquest/widgets/recipe_settings/recipe_settings.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({
    Key? key,
    required this.recipeData,
  }) : super(key: key);

  final RecipeEntry recipeData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RecipeDetails(
              recipeData: recipeData,
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
            const Divider(
              color: Color(0x00000000),
              height: 10,
            ),
            RecipeSettings(
              coffeeSettings: recipeData.coffeeSettings,
            ),
          ],
        ),
      ),
    );
  }
}
