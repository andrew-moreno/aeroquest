import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/screens/onboarding/pages/onboarding_page_template.dart';
import "package:flutter/material.dart";

class OnboardingPage2 extends StatelessWidget {
  const OnboardingPage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OnboardingPageTemplate(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [
          Text(
            "Before getting started...",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 33,
              fontWeight: FontWeight.w500,
              color: kDarkSecondary,
            ),
          ),
        ],
      ),
      bottomText: "Please configure your AeroQuest settings:",
      bottomWidgets: const [],
    );
  }
}
