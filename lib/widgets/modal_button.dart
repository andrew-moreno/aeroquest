import 'package:flutter/material.dart';
import 'package:aeroquest/constraints.dart';

class ModalButton extends StatelessWidget {
  const ModalButton(
      {Key? key,
      required onTap,
      required buttonType,
      required text,
      required width})
      : _onTap = onTap,
        _buttonType = buttonType,
        _text = text,
        _width = width,
        super(key: key);

  final Function() _onTap;
  // defines style of button based on positive or negative use (save vs delete)
  final ButtonType _buttonType;
  final String _text;
  final double? _width;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: _onTap,
        borderRadius: BorderRadius.circular(7),
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: (_buttonType == ButtonType.positive)
                ? kLightSecondary
                : kDeleteRed,
            borderRadius: BorderRadius.circular(kCornerRadius),
            boxShadow: [kBoxShadow],
          ),
          width: _width,
          child: Text(
            _text,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: (_buttonType == ButtonType.positive)
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
