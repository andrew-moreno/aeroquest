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
            controller: controller,
          ),
          const Divider(
            color: Color(0x00000000),
            height: verticalPadding,
          ),
          (_coffee.length > 1)
              ? SmoothPageIndicator(
                  controller: controller,
                  count: _coffee.length,
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
