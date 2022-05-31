import 'package:flutter/material.dart';
import 'package:aeroquest/constraints.dart';

class ModalButton extends StatelessWidget {
  const ModalButton(
      {Key? key,
      required this.onTap,
      required this.buttonType,
      required this.text,
      required this.width})
      : super(key: key);

  final Function() onTap;
  // defines style of button based on positive or negative use (save vs delete)
  final ButtonType buttonType;
  final String text;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(7),
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: (buttonType == ButtonType.positive)
                ? kLightSecondary
                : kDeleteRed,
            borderRadius: BorderRadius.circular(kCornerRadius),
            boxShadow: [kBoxShadow],
          ),
          width: width,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: (buttonType == ButtonType.positive)
                    ? kAccent
                    : kLightSecondary,
                fontFamily: "Poppins",
                fontSize: 20,
                fontWeight: FontWeight.w600),
          ),
        ));
  }
}

enum ButtonType {
  positive,
  negative,
}
