import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/providers/app_settings_provider.dart';
import 'package:aeroquest/screens/app_settings/widgets/setting_types/coffee_unit_setting.dart';
import 'package:aeroquest/screens/app_settings/widgets/setting_types/water_unit_setting.dart';
import 'package:aeroquest/screens/app_settings/widgets/setting_types/temperature_unit_setting.dart';
import 'package:aeroquest/screens/onboarding/pages/onboarding_page_template.dart';
import 'package:aeroquest/widgets/animated_toggle.dart';
import "package:flutter/material.dart";

class OnboardingPage2 extends StatelessWidget {
  const OnboardingPage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OnboardingPageTemplate(
      title: Container(),
      description: Expanded(
        flex: kOnboardingTopFlex,
        child: Image.asset("assets/images/light_icon.png"),
      ),
      bottomText:
          "Before getting started, please configure your AeroQuest units:",
      bottomWidgets: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          SettingsContainer(
            title: "Temperature Unit",
            setting: TemperatureUnitSetting(
              initialTemperatureUnit: TemperatureUnit.celsius,
              toggleType: ToggleType.horizontal,
            ),
          ),
          SettingsContainer(
            title: "Water Amount Unit",
            setting: WaterUnitSetting(
              initialWaterUnit: WaterUnit.gram,
              toggleType: ToggleType.horizontal,
            ),
          ),
          SettingsContainer(
            title: "Coffee Amount Unit",
            setting: CoffeeUnitSetting(),
          ),
        ],
      ),
    );
  }
}

class SettingsContainer extends StatelessWidget {
  const SettingsContainer({
    Key? key,
    required this.title,
    this.description,
    required this.setting,
  }) : super(key: key);

  final String title;
  final String? description;
  final Widget setting;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.left,
          style:
              Theme.of(context).textTheme.subtitle2!.copyWith(color: kSubtitle),
        ),
        (description != null)
            ? Text(
                description!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: kSubtitle,
                  fontFamily: "Poppins",
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
              )
            : Container(),
        setting,
      ],
    );
  }
}
