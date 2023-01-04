import 'package:flutter/material.dart';

import 'package:aeroquest/constraints.dart';

// header includes title, description, and edit button
class CardHeader extends StatelessWidget {
  /// Defines the widget for painting the title and description of a
  /// recipe card or a coffee bean card
  const CardHeader({
    Key? key,
    required this.title,
    this.description,
  }) : super(key: key);

  /// Title to be displayed in the card header
  final String title;

  /// Description to be displayed in the card header
  ///
  /// If null, no description will be displayed
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.headline3!,
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: (description?.isNotEmpty ??
                  false) // if _description is not empty or not null
              ? Text(
                  description!,
                  textAlign: TextAlign.left,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: kLightSecondary),
                )
              : Container(),
        ),
      ],
    );
  }
}
