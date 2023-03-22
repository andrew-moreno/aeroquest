import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/providers/app_settings_provider.dart';
import 'package:aeroquest/screens/app_settings/widgets/setting_types/mass_unit_setting.dart';
import 'package:aeroquest/screens/app_settings/widgets/setting_types/temperature_unit_setting.dart';
import 'package:aeroquest/screens/onboarding/pages/onboarding_page_template.dart';
import 'package:aeroquest/widgets/animated_toggle.dart';
import "package:flutter/material.dart";

class OnboardingPage2 extends StatelessWidget {
  const OnboardingPage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OnboardingPageTemplate(
      background: Container(color: kDarkSecondary),
      title: Container(),
      description: Image.asset(
        "assets/images/dark_icon.png",
        scale: 3,
      ),
      bottomText:
          "Before getting started, please configure your AeroQuest units:",
      bottomWidgets: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            SettingsContainer(
              title: "Temperature Unit",
              setting: TemperatureUnitSetting(
                initialTemperatureUnit: TemperatureUnit.celsius,
                toggleType: ToggleType.vertical,
              ),
            ),
            SettingsContainer(
              title: "Mass Unit",
              setting: MassUnitSetting(
                initialMassUnit: MassUnit.gram,
                toggleType: ToggleType.vertical,
              ),
            ),
          ],
        ),
      ],
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