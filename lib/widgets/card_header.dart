import 'package:flutter/material.dart';

import 'package:aeroquest/constraints.dart';

// header includes title, description, and edit button
class CardHeader extends StatelessWidget {
  const CardHeader({
    Key? key,
    required title,
    description,
  })  : _title = title,
        _description = description,
        super(key: key);

  final String _title;
  final String? _description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _title,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.headline3!,
                ),
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: (_description?.isNotEmpty ??
                  false) // if _description is not empty or not null
              ? Text(
                  _description!,
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
