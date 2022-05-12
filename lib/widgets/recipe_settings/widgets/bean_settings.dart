import 'package:aeroquest/models/recipe_entry.dart';
import 'package:aeroquest/widgets/recipe_settings/widgets/settings_value.dart';
import 'package:flutter/material.dart';
import 'package:aeroquest/constraints.dart';

// template for the settings of a single coffee bean
class BeanSettings extends StatelessWidget {
  const BeanSettings({Key? key, required coffeeSetting})
      : _coffeeSetting = coffeeSetting,
        super(key: key);

  final CoffeeSettings _coffeeSetting;

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
            _coffeeSetting.beanName,
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
                setting: _coffeeSetting.grindSetting.toString(),
                settingType: "Grind",
              ),
              SettingsValue(
                setting: _coffeeSetting.coffeeAmount.toString() + "g",
                settingType: "Coffee",
              ),
              SettingsValue(
                setting: _coffeeSetting.waterAmount.toString() + "g",
                settingType: "Water",
              ),
              SettingsValue(
                setting: _coffeeSetting.waterTemp.toString(),
                settingType: "Temp",
              ),
              SettingsValue(
                setting: _coffeeSetting.brewTime.toString(),
                settingType: "Time",
              ),
            ],
          ),
        ),
      ],
    );
  }
}
