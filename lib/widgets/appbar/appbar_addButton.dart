import 'package:flutter/material.dart';

import '../../constraints.dart';

class AppBarAddButton extends StatelessWidget {
  const AppBarAddButton({Key? key, required onTap, required icon})
      : _onTap = onTap,
        _icon = icon,
        super(key: key);

  final Function()? _onTap;
  final IconData _icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: InkWell(
        onTap: _onTap,
        borderRadius: BorderRadius.circular(7),
        child: Ink(
          decoration: BoxDecoration(
            color: kLightSecondary,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Icon(
            _icon,
            color: kAccent,
            size: 35,
          ),
        ),
      ),
    );
  }
}
