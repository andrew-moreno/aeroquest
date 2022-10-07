import 'package:flutter/material.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:aeroquest/widgets/recipe_settings/widgets/bean_settings.dart';
import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/models/coffee_settings.dart';

// displays bean and recipe settings information
// grind, coffee and water amount, temp, time
class RecipeSettings extends StatelessWidget {
  RecipeSettings({
    Key? key,
    required this.coffeeSettings,
  }) : super(key: key);

  final List<CoffeeSettings> coffeeSettings;
  final _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
          width: double.infinity,
          decoration: BoxDecoration(
            color: kDarkSecondary,
            borderRadius: BorderRadius.circular(kCornerRadius),
          ),
          child: ExpandablePageView(
            // handles scrolling
            controller: _controller,
            children: List.generate(
              coffeeSettings.length,
              (index) => BeanSettings(
                coffeeSetting: coffeeSettings[index],
              ),
            ),
          ),
        ),
        const Divider(
          color: Color(0x00000000),
          height: kRecipeSettingsVerticalPadding,
        ),
        (coffeeSettings.length > 1)
            ? SmoothPageIndicator(
                controller: _controller,
                count: coffeeSettings.length,
                effect: const WormEffect(
                  dotHeight: 6,
                  dotWidth: 6,
                  activeDotColor: kAccent,
                  dotColor: Colors.grey,
                ),
              )
            : Container(),
      ],
    );
  }
}
