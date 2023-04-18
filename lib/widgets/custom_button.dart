import 'package:aeroquest/constraints.dart';

import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  /// Defines the widget for buttons in modal sheets and dialog boxes
  ///
  /// eg. "Save" or "Delete", "Confirm" or "Cancel", etc.
  const CustomButton({
    Key? key,
    required this.onTap,
    required this.buttonType,
    required this.text,
    this.width,
  }) : super(key: key);

  /// Function to execute when the button is pressed
  final Function() onTap;

  /// Defines style of button based on its desired appearance
  final ButtonType buttonType;

  /// Text to be displayed inside the button
  final String text;

  /// Width of the button
  final double? width;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(7),
      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color:
              (buttonType == ButtonType.vibrant) ? kLightSecondary : kDeleteRed,
          borderRadius: BorderRadius.circular(kCornerRadius),
          boxShadow: [kBoxShadow],
        ),
        width: width,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: (buttonType == ButtonType.vibrant)
                  ? kAccent
                  : kLightSecondary,
              fontFamily: "Poppins",
              fontSize: 20,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

/// Describes the type of styling a button will receive
enum ButtonType {
  vibrant,
  normal,
}
