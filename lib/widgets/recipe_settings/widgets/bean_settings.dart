import 'package:aeroquest/providers/recipes_provider.dart';
import 'package:flutter/material.dart';

import 'package:aeroquest/models/recipe_settings.dart';
import 'package:aeroquest/widgets/recipe_parameters_value.dart';
import 'package:aeroquest/constraints.dart';
import 'package:provider/provider.dart';

// template for the settings of a single coffee bean
class BeanSettings extends StatelessWidget {
  const BeanSettings({
    Key? key,
    required this.recipeSetting,
  }) : super(key: key);

  final RecipeSettings recipeSetting;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 0,
          ),
          child: Text(
            Provider.of<RecipesProvider>(context, listen: true)
                .coffeeBeans
                .firstWhere(
                    (coffeeBean) => coffeeBean.id == recipeSetting.beanId)
                .beanName,
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
