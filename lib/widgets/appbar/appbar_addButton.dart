import 'package:flutter/material.dart';

import '../../constraints.dart';

class AppBarAddButton extends StatelessWidget {
  const AppBarAddButton({Key? key, required onTap})
      : _onTap = onTap,
        super(key: key);

  final Function()? _onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: InkWell(
        onTap: _onTap,
        borderRadius: BorderRadius.circular(7),
        child: Ink(
          decoration: BoxDecoration(
            color: kLightNavy,
            borderRadius: BorderRadius.circular(7),
          ),
          child: const Icon(
            Icons.add,
            color: kAccentYellow,
            size: 35,
          ),
        ),
      ),
    );
  }
}
