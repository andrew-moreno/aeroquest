import 'package:flutter/material.dart';
import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/models/recipe.dart';
import 'package:expandable_page_view/expandable_page_view.dart';

// displays bean and recipe settings information
// grind, coffee and water amount, temp, time
class RecipeSettings extends StatelessWidget {
  const RecipeSettings({
    Key? key,
    required coffee,
    required controller,
  })  : _coffee = coffee,
        _controller = controller,
        super(key: key);

  final List<Coffee> _coffee;
  final PageController _controller;

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
            controller: _controller,
            children: List.generate(
              _coffee.length,
              (index) => _buildSettings(context, _coffee, index),
            ),
          ),
        ),
      ],
    );
  }

  // template for the settings of a single coffee type
  Column _buildSettings(ctx, coffee, index) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 2,
          ),
          child: Text(
            coffee[index].name,
            style: Theme.of(ctx)
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
              _buildSettingValue(
                setting: coffee[index].grindSetting.toString(),
                settingType: "Grind",
              ),
              _buildSettingValue(
                setting: coffee[index].coffeeAmount.toString() + "g",
                settingType: "Coffee",
              ),
              _buildSettingValue(
                setting: coffee[index].waterAmount.toString() + "g",
                settingType: "Water",
              ),
              _buildSettingValue(
                setting: coffee[index].waterTemp.toString(),
                settingType: "Temp",
              ),
              _buildSettingValue(
                setting: coffee[index].brewTime.toString(),
                settingType: "Time",
              ),
            ],
          ),
        ),
      ],
    );
  }

  // defines the template for displaying recipe information values
  // eg. grind: 17
  Column _buildSettingValue({ctx, setting, settingType}) {
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
          style: Theme.of(ctx)
              .textTheme
              .subtitle1!
              // kOrangeAccent with transparency
              .copyWith(color: const Color.fromRGBO(182, 124, 107, 0.5)),
        ),
      ],
    );
  }
}
