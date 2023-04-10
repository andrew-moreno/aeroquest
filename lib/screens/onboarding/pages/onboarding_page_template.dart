import 'package:aeroquest/constraints.dart';
import "package:flutter/material.dart";

class OnboardingPageTemplate extends StatelessWidget {
  const OnboardingPageTemplate({
    Key? key,
    required this.title,
    this.description,
    required this.bottomText,
    required this.bottomWidgets,
  }) : super(key: key);

  /// Text to display at the top of the screen
  final Widget title;

  /// Text to display below the title and above the bottom section
  final Widget? description;

  /// Text to display at the top of the bottom section
  final String bottomText;

  /// Widgets to display below [bottomText] and above navigation
  final Widget bottomWidgets;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              title,
              const SizedBox(height: 50),
              description ?? Container(),
              const SizedBox(height: 30),
            ],
          ),
        ),
        Container(
          height: 320,
          color: kDarkSecondary,
          padding: const EdgeInsets.only(
            top: 20,
          ),
          child: Column(
            children: [
              Text(
                bottomText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: kPrimary,
                ),
              ),
              Expanded(
                child: bottomWidgets,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
