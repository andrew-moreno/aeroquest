import 'package:aeroquest/providers/recipes_provider.dart';
import 'package:flutter/material.dart';

import 'package:aeroquest/models/recipe_settings.dart';
import 'package:aeroquest/widgets/recipe_parameters_value.dart';
import 'package:aeroquest/constraints.dart';
import 'package:provider/provider.dart';

class BeanSettings extends StatelessWidget {
  /// Defines the widget used to display recipe settings for a single
  /// coffee bean
  const BeanSettings({
    Key? key,
    required this.recipeSetting,
  }) : super(key: key);

  /// The recipe setting data to use
  final RecipeSettings recipeSetting;

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
                .coffeeBeans[recipeSetting.beanId]!
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
                parameterValue: recipeSetting.grindSetting,
                parameterType: ParameterType.grindSetting,
              ),
              RecipeParameterValue(
                parameterValue: recipeSetting.coffeeAmount,
                parameterType: ParameterType.coffeeAmount,
              ),
              RecipeParameterValue(
                parameterValue: recipeSetting.waterAmount,
                parameterType: ParameterType.waterAmount,
              ),
              RecipeParameterValue(
                parameterValue: recipeSetting.waterTemp,
                parameterType: ParameterType.waterTemp,
              ),
              RecipeParameterValue(
                parameterValue: recipeSetting.brewTime,
                parameterType: ParameterType.brewTime,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
