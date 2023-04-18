import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/providers/app_settings_provider.dart';
import 'package:aeroquest/screens/onboarding/pages/onboarding_page1.dart';
import 'package:aeroquest/screens/onboarding/pages/onboarding_page2.dart';
import 'package:aeroquest/screens/recipes/recipes.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Onboarding extends StatelessWidget {
  /// Defines the widget for displaying the onboarding screens
  Onboarding({Key? key}) : super(key: key);

  static const routeName = "/onboarding";

  final PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: controller,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  OnboardingPage1(),
                  OnboardingPage2(),
                ],
              ),
            ),
            OnboardingNavigation(controller: controller),
          ],
        ),
      ),
    );
  }
}

class OnboardingNavigation extends StatefulWidget {
  /// Widget used for displaying page navigation buttons and indicators
  const OnboardingNavigation({Key? key, required this.controller})
      : super(key: key);

  final PageController controller;

  @override
  State<OnboardingNavigation> createState() => _OnboardingNavigationState();
}

class _OnboardingNavigationState extends State<OnboardingNavigation> {
  int _currentPage = 1;

  static const _pageScrollDuration = Duration(milliseconds: 300);
  static const _pageScrollCurve = Curves.ease;

  /// Function to be executed when the left navigation button is pressed
  ///
  /// Corresponds to the "Back" navigation button
  void _leftButtonOnPressed() {
    setState(() {
      _currentPage = 1;
    });
    widget.controller
        .previousPage(duration: _pageScrollDuration, curve: _pageScrollCurve);
  }

  /// Function to be executed when the right navigation button is pressed
  ///
  /// Corresponds to the "Next" and "Done" navigation buttons
  Future<void> _rightButtonOnPressed() async {
    if (_currentPage == 1) {
      setState(() {
        _currentPage = 2;
      });
      widget.controller
          .nextPage(duration: _pageScrollDuration, curve: _pageScrollCurve);
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(
          Recipes.routeName, (Route<dynamic> route) => false);

      /// Disable onboarding screen from appearing again
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(AppSettingsProvider.isOnboardingSeen, true);

      /// Apply settings changes
      Provider.of<AppSettingsProvider>(
        context,
        listen: false,
      ).updateTemperatureUnit(describeEnum(Provider.of<AppSettingsProvider>(
        context,
        listen: false,
      ).tempTemperatureUnit!));

      Provider.of<AppSettingsProvider>(
        context,
        listen: false,
      ).updateWaterUnit(describeEnum(Provider.of<AppSettingsProvider>(
        context,
        listen: false,
      ).tempWaterUnit!));

      Provider.of<AppSettingsProvider>(
        context,
        listen: false,
      ).updateCoffeeUnit(describeEnum(Provider.of<AppSettingsProvider>(
        context,
        listen: false,
      ).tempCoffeeUnit!));
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle _textStyle = Theme.of(context).textTheme.bodyText2!;
    ButtonStyle _buttonStyle = TextButton.styleFrom(
      foregroundColor: kLightSecondary,
    );
    return Container(
      color: kDarkSecondary,
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed:
                (_currentPage == 1) ? null : () => _leftButtonOnPressed(),
            child: Text(
              (_currentPage == 1) ? "" : "Back",
              style: _textStyle,
            ),
            style: _buttonStyle,
          ),
          SmoothPageIndicator(
            controller: widget.controller,
            count: 2,
            effect: kPageIndicatorEffect,
          ),
          TextButton(
            onPressed: () => _rightButtonOnPressed(),
            child: Text(
              (_currentPage == 1) ? "Next" : "Done",
              style: _textStyle,
            ),
            style: _buttonStyle,
          ),
        ],
      ),
    );
  }
}
