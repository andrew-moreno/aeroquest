import 'package:aeroquest/models/recipe_settings.dart';
import 'package:flutter/material.dart';

import 'package:aeroquest/screens/recipe_details/recipe_details_body/body_widgets/bean_settings_group.dart';
import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/screens/recipe_details/recipe_details_body/body_widgets/recipe_method.dart';
import 'package:aeroquest/models/recipe.dart';

class RecipeDetailsBody extends StatefulWidget {
  const RecipeDetailsBody({
    Key? key,
    required this.recipeData,
    required this.recipeSettingsData,
  }) : super(key: key);

  final Recipe recipeData;
  final List<RecipeSettings> recipeSettingsData;

  @override
  State<RecipeDetailsBody> createState() => _RecipeDetailsBodyState();
}

class _RecipeDetailsBodyState extends State<RecipeDetailsBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kDarkSecondary,
      padding: const EdgeInsets.only(top: 20, left: 35, right: 35, bottom: 20),
      child: Column(
        children: [
          Text(
            "Bean Settings",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline4,
          ),
          const Divider(
            height: 15,
            color: Color(0x00000000),
          ),
          BeanSettingsGroup(
            recipeSettingsData: widget.recipeSettingsData,
          ),
          const Divider(
            height: 30,
            color: Color(0x00000000),
          ),
          Text(
            "Method",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline4,
          ),
          const Divider(
            height: 15,
            color: Color(0x00000000),
          ),
          RecipeMethod(
            pushPressure:
                Recipe.stringToPushPressure(widget.recipeData.pushPressure),
            brewMethod: Recipe.stringToBrewMethod(widget.recipeData.brewMethod),
            notes: const [], //TODO: notes implementation; empty lsit for now
          ),
        ],
      ),
    );
  }
}
