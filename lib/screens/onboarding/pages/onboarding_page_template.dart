import 'package:aeroquest/constraints.dart';
import "package:flutter/material.dart";

class OnboardingPageTemplate extends StatelessWidget {
  const OnboardingPageTemplate({
    Key? key,
    required this.title,
    this.description,
    required this.bottomText,
    required this.bottomWidgets,
    required this.background,
  }) : super(key: key);

  /// Text to display at the top of the screen
  final Widget title;

  /// Text to display below the title and above the bottom section
  final Widget? description;

  /// Text to display at the top of the bottom section
  final String bottomText;

  /// Widgets to display below [bottomText] and above navigation
  final List<Widget> bottomWidgets;

  /// Handles background colour scheme
  final Widget background;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        background,
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: kOnboardingTopFlex,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Spacer(),
                  title,
                  const SizedBox(height: 50),
                  description ?? Container(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
            Expanded(
              flex: kOnboardingBottomFlex,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: bottomWidgets,
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
