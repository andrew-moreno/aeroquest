import 'package:aeroquest/constraints.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  static const routeName = "/onboarding";

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final PageController _controller = PageController();

  int _currentPage = 1;

  static const _scrollAnimationTime = 300;

  void _leftButtonOnPressed() {
    setState(() {
      _currentPage = 1;
    });
    _controller.previousPage(
        duration: const Duration(milliseconds: _scrollAnimationTime),
        curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 10,
                  child: Container(),
                ),
                Expanded(
                  flex: 9,
                  child: Container(
                    color: kDarkSecondary,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _controller,
                    children: const [
                      OnboardingPage1(),
                      OnboardingPage1(),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: (_currentPage == 1)
                        ? null
                        : () => _leftButtonOnPressed(),
                    child: Text(
                      (_currentPage == 1) ? "" : "Back",
                      style: Theme.of(context).textTheme.bodyText2!,
                    ),
                  ),
                  SmoothPageIndicator(
                    controller: _controller,
                    count: 2,
                    effect: kPageIndicatorEffect,
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _currentPage = 2;
                      });
                      _controller.nextPage(
                          duration: const Duration(
                              milliseconds: _scrollAnimationTime),
                          curve: Curves.ease);
                    },
                    child: Text(
                      (_currentPage == 1) ? "Next" : "Done",
                      style: Theme.of(context).textTheme.bodyText2!,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPage1 extends StatelessWidget {
  const OnboardingPage1({Key? key}) : super(key: key);

  static const List<String> tips = [
    "Track and optimise your AeroPress recipes and settings",
    "Record the different coffee beans you're trying",
    "Edit recipe settings based upon your different coffee beans"
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 10,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Icon(
                Icons.coffee,
                color: kDarkSecondary,
                size: 50,
              ),
              SizedBox(height: 30),
              Text(
                "Welcome to",
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
              SizedBox(height: 30),
              Padding(
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
              SizedBox(height: 30),
            ],
          ),
        ),
        Expanded(
          flex: 9,
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 40,
            ),
            child: Column(
              children: [
                const Text(
                  "With AeroQuest, you can...",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: kPrimary,
                  ),
                ),
                const SizedBox(height: 25),
                ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (_, index) => TipsContainer(text: tips[index]),
                  separatorBuilder: (_, index) => const SizedBox(height: 15),
                  itemCount: tips.length,
                ),
              ],
            ),
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
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 15,
      ),
      decoration: BoxDecoration(
        color: kLightSecondary,
        borderRadius: BorderRadius.circular(kCornerRadius),
      ),
      child: IntrinsicHeight(
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: "Poppins",
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: kPrimary,
          ),
        ),
      ),
    );
  }
}
