import 'package:aeroquest/constraints.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  /// Defines the structure of the card that is displayed on all main pages
  ///
  /// eg. Card for Recipes, Coffee Beans, and Settings
  const CustomCard({
    Key? key,
    required this.child,
  }) : super(key: key);

  /// Child for the container
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: kRecipeSettingsVerticalPadding,
        horizontal: 15,
      ),
      decoration: BoxDecoration(
        color: kPrimary,
        borderRadius: BorderRadius.circular(kCornerRadius),
        boxShadow: [kBoxShadow],
      ),
      child: child,
    );
  }
}
