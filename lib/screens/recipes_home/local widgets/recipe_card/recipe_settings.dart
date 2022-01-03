import 'package:flutter/material.dart';
import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/models/recipe.dart';
import 'package:expandable_page_view/expandable_page_view.dart';

// displays bean and recipe settings information
// grind, coffee and water amount, temp, time
class RecipeSettings extends StatelessWidget {
  RecipeSettings({
    Key? key,
    required this.coffee,
    required this.controller,
  }) : super(key: key);

  final List<Coffee> coffee;
  final PageController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: kDarkNavy,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ExpandablePageView(
            // handles scrolling
            controller: controller,
            children: List.generate(
              coffee.length,
              (index) => _SettingsTemplate(
                coffee: coffee,
                index: index,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// template for the settings of a single coffee type
class _SettingsTemplate extends StatelessWidget {
  const _SettingsTemplate({
    Key? key,
    required this.coffee,
    required this.index,
  }) : super(key: key);

  final List<Coffee> coffee;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 2,
          ),
          child: Text(
            coffee[index].name,
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(color: kDarkSubtitleColor),
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
            color: kMediumNavy,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _SettingValueTemplate(
                setting: coffee[index].grindSetting.toString(),
                settingType: "Grind",
              ),
              _SettingValueTemplate(
                setting: coffee[index].coffeeAmount.toString() + "g",
                settingType: "Coffee",
              ),
              _SettingValueTemplate(
                setting: coffee[index].waterAmount.toString() + "g",
                settingType: "Water",
              ),
              _SettingValueTemplate(
                setting: coffee[index].waterTemp.toString(),
                settingType: "Temp",
              ),
              _SettingValueTemplate(
                setting: coffee[index].brewTime.toString(),
                settingType: "Time",
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// defines the template for displaying recipe information values
// eg. grind: 17
class _SettingValueTemplate extends StatelessWidget {
  const _SettingValueTemplate(
      {Key? key, required this.setting, required this.settingType})
      : super(key: key);

  final String setting;
  final String settingType;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          setting,
          style: const TextStyle(
            color: kAccentOrange,
            fontFamily: "Poppins",
            fontSize: 19,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          settingType,
          style: Theme.of(context)
              .textTheme
              .subtitle1!
              .copyWith(color: const Color.fromRGBO(182, 124, 107, 0.5)),
        ),
      ],
    );
  }
}
