import 'package:flutter/material.dart';
import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/models/recipe_entry.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// displays bean and recipe settings information
// grind, coffee and water amount, temp, time
class RecipeSettings extends StatelessWidget {
  RecipeSettings({
    Key? key,
    required coffee,
    required verticalPadding,
  })  : _coffee = coffee,
        _verticalPadding = verticalPadding,
        super(key: key);

  final List<CoffeeSetting> _coffee;
  final _controller = PageController();
  final double _verticalPadding;

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
        Divider(
          color: const Color(0x00000000),
          height: _verticalPadding,
        ),
        (_coffee.length > 1)
            ? SmoothPageIndicator(
                controller: _controller,
                count: _coffee.length,
                effect: const WormEffect(
                  dotHeight: 6,
                  dotWidth: 6,
                  activeDotColor: kAccentYellow,
                  dotColor: kBackgroundColor,
                ),
              )
            : Container(),
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
            coffee[index].beanName,
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
                ctx,
                coffee[index].grindSetting.toString(),
                "Grind",
              ),
              _buildSettingValue(
                ctx,
                coffee[index].coffeeAmount.toString() + "g",
                "Coffee",
              ),
              _buildSettingValue(
                ctx,
                coffee[index].waterAmount.toString() + "g",
                "Water",
              ),
              _buildSettingValue(
                ctx,
                coffee[index].waterTemp.toString(),
                "Temp",
              ),
              _buildSettingValue(
                ctx,
                coffee[index].brewTime.toString(),
                "Time",
              ),
            ],
          ),
        ),
      ],
    );
  }

  // defines the template for displaying recipe information values
  // eg. grind: 17
  Column _buildSettingValue(ctx, setting, settingType) {
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
