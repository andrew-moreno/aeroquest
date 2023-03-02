import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

const kPrimary = Color(0xFFD8D4CF);
const kDarkSecondary = Color(0xFF17233A);
const kLightSecondary = Color(0xFF26395D);
const kAccent = Color(0xFFF58C95);
const kAccentTransparent = Color.fromRGBO(245, 140, 149, 0.5);
const kSubtitle = Color(0xFF5875B1);
const kDeleteRed = Color(0xFFF64353);

const kInputDecorationHorizontalPadding = 15.0;
const kRecipeSettingsVerticalPadding = 7.0;
const kRecipeDetailsVerticalPadding = 15.0;

/// Defines padding for main pages
///
/// eg. Recipes, Coffee Beans, Settings
const kRoutePagePadding = 20.0;
const kCornerRadius = 10.0;
const kModalCornerRadius = 25.0;

const kOnboardingTopFlex = 10;
const kOnboardingBottomFlex = 9;

const kPageIndicatorEffect = WormEffect(
  dotHeight: 6,
  dotWidth: 6,
  activeDotColor: kAccent,
  dotColor: Colors.grey,
);
final kBoxShadow = BoxShadow(
  color: Colors.black.withOpacity(0.2),
  offset: const Offset(0, 3),
  spreadRadius: 0,
  blurRadius: 7,
);
final kSettingsBoxShadow = BoxShadow(
  color: Colors.black.withOpacity(0.3),
  offset: const Offset(0, 3),
  spreadRadius: 0,
  blurRadius: 7,
);
