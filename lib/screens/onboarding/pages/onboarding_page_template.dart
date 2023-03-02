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

  final Widget title;
  final Widget? description;
  final String bottomText;
  final List<Widget> bottomWidgets;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: kOnboardingTopFlex,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              const Icon(
                Icons.coffee,
                color: kDarkSecondary,
                size: 50,
              ),
              const SizedBox(height: 30),
              title,
              const Spacer(),
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
              horizontal: 40,
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
                Column(
                  children: bottomWidgets,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
