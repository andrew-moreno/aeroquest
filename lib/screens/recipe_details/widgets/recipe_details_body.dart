import 'package:aeroquest/models/recipe_entry.dart';
import 'package:aeroquest/widgets/recipe_settings/recipe_settings.dart';
import 'package:flutter/material.dart';
import 'package:aeroquest/constraints.dart';

class RecipeDetailsBody extends StatefulWidget {
  const RecipeDetailsBody({Key? key, required recipeData})
      : _recipeData = recipeData,
        super(key: key);

  final RecipeEntry _recipeData;

  @override
  State<RecipeDetailsBody> createState() => _RecipeDetailsBodyState();
}

class _RecipeDetailsBodyState extends State<RecipeDetailsBody> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
            color: kDarkSecondary,
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(kModalCornerRadius))),
        width: double.infinity,
        child: Column(
          children: [
            Text(
              "Bean Settings",
              style: Theme.of(context).textTheme.headline4,
            ),
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                itemCount: widget._recipeData.coffeeSettings.length,
                itemBuilder: (BuildContext context, int index) {
                  return RecipeSettings(
                    coffeeSettings: widget._recipeData.coffeeSettings,
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    color: Color(0x00000000),
                    height: 10,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
