import 'package:flutter/material.dart';

import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/widgets/modal_button.dart';

class ExitDialog extends StatelessWidget {
  const ExitDialog(
      {Key? key,
      required this.titleText,
      required this.leftAction,
      required this.rightAction,
      this.leftText = "No",
      this.rightText = "Yes"})
      : super(key: key);

  final String titleText;
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
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: [
        ModalButton(
            onTap: leftAction,
            buttonType: ButtonType.positive,
            text: leftText,
            width: 100.0),
        ModalButton(
            onTap: rightAction,
            buttonType: ButtonType.negative,
            text: rightText,
            width: 100.0)
      ],
      backgroundColor: kDarkSecondary,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kCornerRadius)),
    );
  }
}
