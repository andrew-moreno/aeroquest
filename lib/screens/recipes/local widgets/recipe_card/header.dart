import 'package:flutter/material.dart';
import 'package:aeroquest/constraints.dart';

// header includes title, description, and edit button
class Header extends StatelessWidget {
  const Header({
    Key? key,
    required title,
    required description,
  })  : _title = title,
        _description = description,
        super(key: key);

  final String _title;
  final String _description;

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
                  style: const TextStyle(
                    color: kTextColor,
                    fontFamily: "Spectral",
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            Material(
              color: kLightNavy,
              child: InkWell(
                onTap: () {
                  print("Hello");
                },
                borderRadius: BorderRadius.circular(7),
                child: Ink(
                  padding: const EdgeInsets.all(5),
                  child: const Icon(
                    Icons.edit,
                    color: kAccentYellow,
                    size: 24,
                  ),
                ),
              ),
            )
          ],
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            _description,
            textAlign: TextAlign.left,
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(color: kSubtitleColor),
          ),
        ),
      ],
    );
  }
}
