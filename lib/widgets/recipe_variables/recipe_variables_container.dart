import 'package:aeroquest/models/recipe_variables.dart';
import 'package:aeroquest/widgets/recipe_variables/widgets/bean_variables.dart';
import 'package:aeroquest/constraints.dart';

import 'package:flutter/material.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class RecipeVariablesContainer extends StatelessWidget {
  /// Defines the widget that contains the recipe variables per coffee bean
  RecipeVariablesContainer({
    Key? key,
    required this.recipeVariables,
  }) : super(key: key);

  /// The list of recipe variables to be displayed
  ///
  /// If [recipeVariables.length] > 1, this widget becomes scrollable
  final List<RecipeVariables> recipeVariables;

  /// Controller used to handle page scrolling
  ///
  /// Viewport fraction of 1.02 provides adequate spacing between recipe
  /// variables
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
            child: (recipeVariables.length > 1)
                ? ExpandablePageView(
                    controller: _controller,
                    children: List.generate(
                      recipeVariables.length,
                      (index) => FractionallySizedBox(
                        widthFactor: 1 / _controller.viewportFraction,
                        child: BeanVariables(
                          recipeVariables: recipeVariables[
                              recipeVariables.length - index - 1],
                        ),
                      ),
                    ),
                  )
                : BeanVariables(
                    recipeVariables: recipeVariables[0],
                  ),
          ),
        ),
        const SizedBox(height: kRecipeVariablesVerticalPadding),
        (recipeVariables.length > 1)
            ? SmoothPageIndicator(
                controller: _controller,
                count: recipeVariables.length,
                effect: kPageIndicatorEffect,
              )
            : Container(),
      ],
    );
  }
}
