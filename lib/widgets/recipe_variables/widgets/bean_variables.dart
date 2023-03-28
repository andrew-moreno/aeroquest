import 'package:aeroquest/providers/recipes_provider.dart';
import 'package:flutter/material.dart';

import 'package:aeroquest/models/recipe_variables.dart';
import 'package:aeroquest/widgets/recipe_parameters_value.dart';
import 'package:aeroquest/constraints.dart';
import 'package:provider/provider.dart';

class BeanVariables extends StatelessWidget {
  /// Defines the widget used to display recipe variables for a single
  /// coffee bean
  const BeanVariables({
    Key? key,
    required this.recipeVariables,
  }) : super(key: key);

  /// The recipe variables data to use
  final RecipeVariables recipeVariables;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 1,
          ),
          child: Text(
            Provider.of<RecipesProvider>(context, listen: true)
                .coffeeBeans[recipeVariables.beanId]!
                .beanName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(color: kSubtitle),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: kLightSecondary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RecipeParameterValue(
                parameterValue: recipeVariables.grindSetting,
                parameterType: ParameterType.grindSetting,
              ),
              RecipeParameterValue(
                parameterValue: recipeVariables.coffeeAmount,
                parameterType: ParameterType.coffeeAmount,
              ),
              RecipeParameterValue(
                parameterValue: recipeVariables.waterAmount,
                parameterType: ParameterType.waterAmount,
              ),
              RecipeParameterValue(
                parameterValue: recipeVariables.waterTemp,
                parameterType: ParameterType.waterTemp,
              ),
              RecipeParameterValue(
                parameterValue: recipeVariables.brewTime,
                parameterType: ParameterType.brewTime,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
