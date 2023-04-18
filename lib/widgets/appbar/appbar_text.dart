import 'package:flutter/material.dart';

class AppBarText extends StatelessWidget {
  /// Defines the widget used for the text in the app bar
  const AppBarText({
    Key? key,
    required this.text,
  }) : super(key: key);

  /// The text to be displayed in the app bar
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.fade,
      style: Theme.of(context).textTheme.headline2!,
    );
  }
}
