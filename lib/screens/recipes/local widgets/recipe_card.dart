import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/models/recipe.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

import 'recipe_card/header.dart';
import 'recipe_card/recipe_settings.dart';
import 'recipe_card/recipe_method.dart';

class RecipeCard extends StatelessWidget {
  RecipeCard({
    Key? key,
    required title,
    required description,
    required coffee,
    required pushPressure,
    required brewMethod,
    required notes,
  })  : _title = title,
        _description = description,
        _coffee = coffee,
        _pushPressure = pushPressure,
        _brewMethod = brewMethod,
        _notes = notes,
        super(key: key);

  final String _title;
  final String _description;
  final List<Coffee> _coffee;
  final PushPressure _pushPressure;
  final BrewMethod _brewMethod;
  final List<Notes> _notes;

  static const double verticalPadding = 7;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("Tapped");
      },
      child: ExpandableNotifier(
        child: Column(
          children: [
            ExpandableButton(
              theme: const ExpandableThemeData(useInkWell: false),
              child: _buildMainRecipeCard(),
            ),
            Expandable(
              collapsed: Container(),
              expanded: Column(
                children: [
                  RecipeMethod(
                    pushPressure: _pushPressure,
                    brewMethod: _brewMethod,
                    notes: _notes,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Container _buildMainRecipeCard() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: verticalPadding,
        horizontal: 15,
      ),
      decoration: BoxDecoration(
        color: kLightNavy,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Header(
            title: _title,
            description: _description,
          ),
          const Divider(
            color: Color(0x00000000),
            height: 10,
          ),
          RecipeSettings(
            coffee: _coffee,
            verticalPadding: verticalPadding,
          ),
        ],
      ),
    );
  }
}
