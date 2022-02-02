import 'package:flutter/material.dart';
import 'package:aeroquest/constraints.dart';

// header includes title, description, and edit button
class CardHeader extends StatelessWidget {
  const CardHeader({
    Key? key,
    required title,
    description,
    required actions,
  })  : _title = title,
        _description = description,
        _actions = actions,
        super(key: key);

  final String _title;
  final String? _description;
  final List<Widget> _actions;

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
            Row(
              children: _actions,
            )
          ],
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: (_description != null)
              ? Text(
                  _description!,
                  textAlign: TextAlign.left,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: kSubtitleColor),
                )
              : Container(),
        ),
      ],
    );
  }
}
