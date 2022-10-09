import 'package:aeroquest/providers/recipes_provider.dart';
import 'package:flutter/material.dart';

import 'package:aeroquest/models/recipe_settings.dart';
import 'package:aeroquest/widgets/recipe_settings/widgets/settings_value.dart';
import 'package:aeroquest/constraints.dart';
import 'package:provider/provider.dart';

// template for the settings of a single coffee bean
class BeanSettings extends StatelessWidget {
  const BeanSettings({Key? key, required this.recipeSetting}) : super(key: key);

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
              SettingsValue(
                settingValue: recipeSetting.grindSetting,
                settingType: SettingType.grindSetting,
              ),
              SettingsValue(
                settingValue: recipeSetting.coffeeAmount,
                settingType: SettingType.coffeeAmount,
              ),
              SettingsValue(
                settingValue: recipeSetting.waterAmount,
                settingType: SettingType.waterAmount,
              ),
              SettingsValue(
                settingValue: recipeSetting.waterTemp,
                settingType: SettingType.waterTemp,
              ),
              SettingsValue(
                settingValue: recipeSetting.brewTime,
                settingType: SettingType.brewTime,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
