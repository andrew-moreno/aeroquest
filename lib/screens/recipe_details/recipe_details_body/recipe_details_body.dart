import 'package:flutter/material.dart';

import 'package:aeroquest/screens/recipe_details/recipe_details_body/body_widgets/bean_settings_group.dart';
import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/screens/recipe_details/recipe_details_body/body_widgets/recipe_method.dart';

class RecipeDetailsBody extends StatefulWidget {
  const RecipeDetailsBody({
    Key? key,
    required this.recipeId,
  }) : super(key: key);

  final int recipeId;

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
            recipeEntryId: widget.recipeId,
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
          const RecipeMethod(),
        ],
      ),
    );
  }
}
