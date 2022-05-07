import 'package:aeroquest/models/recipe_entry.dart';
import 'package:aeroquest/widgets/recipe_settings/widgets/settings_value.dart';
import 'package:flutter/material.dart';
import 'package:aeroquest/constraints.dart';

// template for the settings of a single coffee bean
class BeanSettings extends StatelessWidget {
  const BeanSettings({Key? key, required coffeeSettings, required index})
      : _coffeeSettings = coffeeSettings,
        _index = index,
        super(key: key);

  final List<CoffeeSettings> _coffeeSettings;
  final int _index;

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
            _coffeeSettings[_index].beanName,
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(color: kSubtitle),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(
            left: 5,
            right: 5,
            bottom: 5,
          ),
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: kLightSecondary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SettingsValue(
                setting: _coffeeSettings[_index].grindSetting.toString(),
                settingType: "Grind",
              ),
              SettingsValue(
                setting: _coffeeSettings[_index].coffeeAmount.toString() + "g",
                settingType: "Coffee",
              ),
              SettingsValue(
                setting: _coffeeSettings[_index].waterAmount.toString() + "g",
                settingType: "Water",
              ),
              SettingsValue(
                setting: _coffeeSettings[_index].waterTemp.toString(),
                settingType: "Temp",
              ),
              SettingsValue(
                setting: _coffeeSettings[_index].brewTime.toString(),
                settingType: "Time",
              ),
            ],
          ),
        ),
      ],
    );
  }
}
