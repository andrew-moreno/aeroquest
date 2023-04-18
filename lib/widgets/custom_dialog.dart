import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/widgets/custom_button.dart';

import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  /// Defines the widget used for a dialog box
  const CustomDialog({
    Key? key,
    required this.titleText,
    this.description,
    required this.leftAction,
    required this.rightAction,
    this.leftButtonText = "No",
    this.rightButtonText = "Yes",
  }) : super(key: key);

  /// Title to display at the top of the dialog box
  final String titleText;

  /// Description to display in the main body of the dialog box
  ///
  /// If null, no description will be displayed
  final String? description;

  /// Function to execute when the button on the left side of the dialog box
  /// is pressed
  final Function() leftAction;

  /// Function to execute when the button on the right side of the dialog box
  /// is pressed
  final Function() rightAction;

  /// Text to display within the left side button
  final String leftButtonText;

  /// Text to display within the right side button
  final String rightButtonText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        titleText,
        style: const TextStyle(
          color: kPrimary,
          fontFamily: "Poppins",
          fontWeight: FontWeight.w500,
          fontSize: 20,
        ),
      ),
      content: (description != null)
          ? Text(
              description!,
              style: const TextStyle(
                color: kPrimary,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w400,
                fontSize: 15,
              ),
            )
          : null,
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: [
        CustomButton(
          onTap: leftAction,
          buttonType: ButtonType.vibrant,
          text: leftButtonText,
          width: 100.0,
        ),
        CustomButton(
          onTap: rightAction,
          buttonType: ButtonType.normal,
          text: rightButtonText,
          width: 100.0,
        )
      ],
      backgroundColor: kDarkSecondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kCornerRadius),
      ),
    );
  }
}
