import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/widgets/card_header.dart';
import 'package:aeroquest/widgets/custom_card.dart';

import 'package:flutter/material.dart';

class SettingCard extends StatelessWidget {
  /// Defines the widget used for displaying information about the various
  /// settings
  const SettingCard({
    Key? key,
    required this.settingValue,
    required this.onTap,
    required this.title,
    required this.description,
  }) : super(key: key);

  /// Current value that is set for the respective setting
  final String settingValue;

  /// Function to execute when pressing the card
  final void Function() onTap;

  /// Title to be displayed in the card
  final String title;

  /// Description to be displayed in the card
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
              child: Text(settingValue,
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
