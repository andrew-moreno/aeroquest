import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/screens/onboarding/pages/onboarding_page_template.dart';
import "package:flutter/material.dart";

class OnboardingPage1 extends StatelessWidget {
  /// Defines the first page of the series of onboarding screens
  const OnboardingPage1({Key? key}) : super(key: key);

  /// List of ways to use AeroQuest
  static const List<String> tips = [
    "Track and optimise your favourite AeroPress recipes and their brewing variables",
    "Save the various coffee beans you're trying with each brew",
    "Adjust recipe variables for individual coffee beans"
  ];

  @override
  Widget build(BuildContext context) {
    return OnboardingPageTemplate(
      background: Column(
        children: [
          Expanded(
            flex: kOnboardingTopFlex,
            child: Container(),
          ),
          Expanded(
            flex: kOnboardingBottomFlex,
            child: Container(
              color: kDarkSecondary,
            ),
          ),
        ],
      ),
      title: Column(
        children: const [
          Text(
            "Welcome to",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 33,
              fontWeight: FontWeight.w500,
              color: kDarkSecondary,
            ),
          ),
          Text(
            "AeroQuest",
            style: TextStyle(
              fontFamily: "Spectral",
              fontSize: 50,
              fontWeight: FontWeight.w700,
              color: kDarkSecondary,
            ),
          ),
        ],
      ),
      description: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.0),
        child: Text(
          "AeroQuest is a companion app for getting the most out of each "
          "AeroPress brew",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color: kDarkSecondary,
          ),
        ),
      ),
      bottomText: "With AeroQuest, you can...",
      bottomWidgets: Padding(
        padding: const EdgeInsets.only(
          left: 40.0,
          right: 40,
          top: 20,
        ),
        child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (_, index) => TipsContainer(text: tips[index]),
          separatorBuilder: (_, index) => const SizedBox(height: 25),
          itemCount: tips.length,
        ),
      ),
    );
  }
}

class TipsContainer extends StatelessWidget {
  /// Defines the widget used for containing the tips to show users
  const TipsContainer({Key? key, required this.text}) : super(key: key);

  /// Text to display within the container
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            "• ",
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: kAccent,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: "Poppins",
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: kPrimary,
              ),
            ),
          ),
        ],
      ),
    );

    /// TipsContainer using coloured rounded rectangle

    // return Container(
    //   padding: const EdgeInsets.symmetric(
    //     vertical: 8,
    //     horizontal: 15,
    //   ),
    //   // decoration: BoxDecoration(
    //   //   color: kLightSecondary,
    //   //   borderRadius: BorderRadius.circular(kCornerRadius),
    //   // ),
    //   child: Text(
    //     text,
    //     style: const TextStyle(
    //       fontFamily: "Poppins",
    //       fontSize: 13,
    //       fontWeight: FontWeight.w500,
    //       color: kPrimary,
    //     ),
    //   ),
    // );
  }
}
