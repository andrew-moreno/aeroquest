import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/screens/onboarding/pages/onboarding_page_template.dart';
import "package:flutter/material.dart";

class OnboardingPage1 extends StatelessWidget {
  const OnboardingPage1({Key? key}) : super(key: key);

  static const List<String> tips = [
    "Track and optimise your AeroPress recipes and settings",
    "Record the different coffee beans you're trying",
    "Edit recipe settings based upon your different coffee beans"
  ];

  @override
  Widget build(BuildContext context) {
    return OnboardingPageTemplate(
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
          "AeroQuest is a companion app for recording all your "
          "favourite AeroPress recipes",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 17,
            fontWeight: FontWeight.w400,
            color: kDarkSecondary,
          ),
        ),
      ),
      bottomText: "With AeroQuest, you can...",
      bottomWidgets: [
        const SizedBox(height: 35),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (_, index) => TipsContainer(text: tips[index]),
            separatorBuilder: (_, index) => const SizedBox(height: 25),
            itemCount: tips.length,
          ),
        ),
      ],
    );
  }
}

class TipsContainer extends StatelessWidget {
  const TipsContainer({Key? key, required this.text}) : super(key: key);

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
