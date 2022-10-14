import 'package:flutter/material.dart';

import 'package:aeroquest/constraints.dart';

class AppBarLeading extends StatelessWidget {
  const AppBarLeading({
    Key? key,
    required this.function,
    this.onPressed,
  }) : super(key: key);

  final LeadingFunction function;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    IconButton _leadingButton(LeadingFunction action) {
      switch (action) {
        case LeadingFunction.menu:
          return IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: const Icon(
              Icons.menu,
              color: kLightSecondary,
              size: 30,
            ),
          );
        case LeadingFunction.back:
          return IconButton(
            onPressed: onPressed ?? () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back,
              color: kLightSecondary,
              size: 30,
            ),
          );
      }
    }

    return _leadingButton(function);
  }
}

enum LeadingFunction {
  menu,
  back,
}
