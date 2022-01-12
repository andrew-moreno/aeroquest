import 'package:flutter/material.dart';

class AppBarText extends StatelessWidget {
  const AppBarText({Key? key, required text})
      : _text = text,
        super(key: key);

  final String _text;

  @override
  Widget build(BuildContext context) {
    return Text(
      _text,
      style: Theme.of(context).textTheme.headline2!,
    );
  }
}
