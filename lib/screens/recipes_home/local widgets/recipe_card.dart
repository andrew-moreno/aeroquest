import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/models/recipe.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'recipe_card/header.dart';
import 'recipe_card/recipe_settings.dart';
import 'recipe_card/recipe_method.dart';

class RecipeCard extends StatelessWidget {
  RecipeCard({
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

  final controller = PageController();
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
            Expandable(
              collapsed: ExpandableButton(
                theme: const ExpandableThemeData(useInkWell: false),
                child: _buildMainRecipeCard(),
              ),
              expanded: Column(
                children: [
                  ExpandableButton(
                    theme: const ExpandableThemeData(useInkWell: false),
                    child: _buildMainRecipeCard(),
                  ),
                  RecipeMethod(
                    pushPressure: pushPressure,
                    brewMethod: brewMethod,
                    notes: notes,
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
            title: title,
            description: description,
          ),
          const Divider(
            color: Color(0x00000000),
            height: 10,
          ),
          RecipeSettings(
            coffee: coffee,
            controller: controller,
          ),
          const Divider(
            color: Color(0x00000000),
            height: verticalPadding,
          ),
          (coffee.length > 1)
              ? SmoothPageIndicator(
                  controller: controller,
                  count: coffee.length,
                  effect: const WormEffect(
                    dotHeight: 6,
                    dotWidth: 6,
                    activeDotColor: kAccentYellow,
                    dotColor: kBackgroundColor,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
