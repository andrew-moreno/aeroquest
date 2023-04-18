import 'package:aeroquest/constraints.dart';

import 'package:flutter/material.dart';

class AppBarLeading extends StatelessWidget {
  /// Defines the widget used for the leading button in the app bar
  const AppBarLeading({
    Key? key,
    required this.leadingFunction,
    this.onTap,
  }) : super(key: key);

  /// Defines whether the button is used for the drawer or for a back button
  final LeadingFunction leadingFunction;

  /// Function to execute when the button is pressed
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: (leadingFunction == LeadingFunction.menu)
          ? () => Scaffold.of(context).openDrawer()
          : onTap ?? () => Navigator.of(context).pop(),
      icon: Icon(
        (leadingFunction == LeadingFunction.menu)
            ? Icons.menu
            : Icons.arrow_back,
        color: kLightSecondary,
        size: 30,
      ),
    );
  }
}

/// Describes the possible functions that can be executed by a user on the
/// left side of the app bar
enum LeadingFunction {
  menu,
  back,
}
