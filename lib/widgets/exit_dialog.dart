import 'package:flutter/material.dart';

import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/widgets/modal_button.dart';

class ExitDialog extends StatelessWidget {
  const ExitDialog(
      {Key? key,
      required titleText,
      required leftAction,
      required rightAction,
      leftText = "No",
      rightText = "Yes"})
      : _titleText = titleText,
        _leftAction = leftAction,
        _rightAction = rightAction,
        _leftText = leftText,
        _rightText = rightText,
        super(key: key);

  final String _titleText;
  final Function _leftAction;
  final Function _rightAction;
  final String _leftText;
  final String _rightText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        _titleText,
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
            onTap: _leftAction,
            buttonType: ButtonType.positive,
            text: _leftText,
            width: 100.0),
        ModalButton(
            onTap: _rightAction,
            buttonType: ButtonType.negative,
            text: _rightText,
            width: 100.0)
      ],
      backgroundColor: kDarkSecondary,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kCornerRadius)),
    );
  }
}
