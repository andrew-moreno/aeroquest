import 'package:aeroquest/models/recipe_settings.dart';
import 'package:flutter/material.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:aeroquest/widgets/recipe_settings/widgets/bean_settings.dart';
import 'package:aeroquest/constraints.dart';

class RecipeSettingsContainer extends StatelessWidget {
  /// Defines the widget that contains the recipe settings per coffee bean
  RecipeSettingsContainer({
    Key? key,
    required this.recipeSettings,
  }) : super(key: key);

  /// The list of recipe settings to be displayed
  ///
  /// If [recipeSettings.length] > 1, this widget becomes scrollable
  final List<RecipeSettings> recipeSettings;

  /// Controller used to handle page scrolling
  ///
  /// Viewport fraction of 1.02 provides adequate spacing between recipe
  /// settings
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
                          recipeSetting:
                              recipeSettings[recipeSettings.length - index - 1],
                        ),
                      ),
                    ),
                  )
                : BeanSettings(
                    recipeSetting: recipeSettings[0],
                  ),
          ),
        ),
        const SizedBox(height: kRecipeSettingsVerticalPadding),
        (recipeSettings.length > 1)
            ? SmoothPageIndicator(
                controller: _controller,
                count: recipeSettings.length,
                effect: kPageIndicatorEffect,
              )
            : Container(),
      ],
    );
  }
}
