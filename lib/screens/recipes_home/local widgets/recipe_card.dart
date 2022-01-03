import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/models/recipe.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

import 'recipe_card/header.dart';
import 'recipe_card/recipe_settings.dart';
import 'recipe_card/recipe_method.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({
    Key? key,
    required this.title,
    required this.description,
    required this.coffee,
    required this.pushPressure,
    required this.brewMethod,
    required this.notes,
  }) : super(key: key);

  final String title;
  final String description;
  final List<Coffee> coffee;
  final PushPressure pushPressure;
  final BrewMethod brewMethod;
  final List<Notes> notes;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("Tapped");
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 15,
            ),
            decoration: BoxDecoration(
              color: kLightNavy,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Header(
                  title: title,
                  description: description,
                ),
                const Divider(
                  color: Color(0x00000000),
                  height: 10,
                ),
                RecipeSettings(coffee: coffee),
              ],
            ),
          ),
          RecipeMethod(
            pushPressure: pushPressure,
            brewMethod: brewMethod,
            notes: notes,
          )
        ],
      ),
    );
  }
}
