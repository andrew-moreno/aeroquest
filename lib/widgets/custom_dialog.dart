import 'package:flutter/material.dart';

import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/widgets/custom_button.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog(
      {Key? key,
      required this.titleText,
      this.description,
      required this.leftAction,
      required this.rightAction,
      this.leftText = "No",
      this.rightText = "Yes"})
      : super(key: key);

  final String titleText;
  final String? description;
  final Function() leftAction;
  final Function() rightAction;
  final String leftText;
  final String rightText;

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
          buttonType: ButtonType.positive,
          text: leftText,
          width: 100.0,
        ),
        CustomButton(
          onTap: rightAction,
          buttonType: ButtonType.negative,
          text: rightText,
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
