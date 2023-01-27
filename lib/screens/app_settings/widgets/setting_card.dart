import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/widgets/card_header.dart';
import 'package:aeroquest/widgets/custom_card.dart';
import 'package:flutter/material.dart';

class SettingCard extends StatelessWidget {
  const SettingCard({
    Key? key,
    required this.text,
    required this.onTap,
    required this.title,
    required this.description,
  }) : super(key: key);

  final String text;
  final void Function() onTap;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomCard(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CardHeader(title: title, description: description),
            ),
            Container(
              margin: const EdgeInsets.only(left: 15),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              decoration: BoxDecoration(
                color: kLightSecondary,
                borderRadius: BorderRadius.circular(kCornerRadius),
                boxShadow: [kBoxShadow],
              ),
              child: Text(text,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 17)),
            ),
          ],
        ),
      ),
    );
  }
}
