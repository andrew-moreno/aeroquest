import 'package:aeroquest/models/recipe_settings.dart';
import 'package:flutter/material.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:aeroquest/widgets/recipe_settings/widgets/bean_settings.dart';
import 'package:aeroquest/constraints.dart';

// displays bean and recipe settings information
// grind, coffee and water amount, temp, time
class RecipeSettingsContainer extends StatelessWidget {
  RecipeSettingsContainer({
    Key? key,
    required this.recipeSettings,
  }) : super(key: key);

  final List<RecipeSettings> recipeSettings;
  final _controller = PageController(viewportFraction: 1.02);

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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: (recipeSettings.length > 1)
                ? ExpandablePageView(
                    controller: _controller,
                    children: List.generate(
                      recipeSettings.length,
                      (index) => FractionallySizedBox(
                        widthFactor: 1 / _controller.viewportFraction,
                        child: BeanSettings(
                          recipeSetting: recipeSettings[index],
                        ),
                      ),
                    ),
                  )
                : BeanSettings(
                    recipeSetting: recipeSettings[0],
                  ),
          ),
        ),
        const Divider(
          color: Color(0x00000000),
          height: kRecipeSettingsVerticalPadding,
        ),
        (recipeSettings.length > 1)
            ? SmoothPageIndicator(
                controller: _controller,
                count: recipeSettings.length,
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
