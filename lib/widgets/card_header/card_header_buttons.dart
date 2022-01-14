import 'package:flutter/material.dart';

import '../../constraints.dart';

class CardHeaderButton extends StatelessWidget {
  const CardHeaderButton({Key? key, required icon, required onTap})
      : _icon = icon,
        _onTap = onTap,
        super(key: key);

  final IconData? _icon;
  final Function() _onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kLightNavy,
      child: InkWell(
        onTap: _onTap,
        borderRadius: BorderRadius.circular(7),
        child: Ink(
          padding: const EdgeInsets.all(5),
          child: Icon(
            _icon,
            color: kAccentYellow,
            size: 24,
          ),
        ),
      ),
    );
  }
}
