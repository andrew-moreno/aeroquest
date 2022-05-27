import 'package:flutter/material.dart';
import 'package:aeroquest/constraints.dart';

// defines the template for displaying recipe information values
// eg. grind: 17
class SettingsValue extends StatefulWidget {
  const SettingsValue(
      {Key? key, required this.setting, required this.settingType})
      : super(key: key);

  final String setting;
  final String settingType;

  @override
  State<SettingsValue> createState() => _SettingsValueState();
}

class _SettingsValueState extends State<SettingsValue> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.setting,
          style: const TextStyle(
            color: kAccent,
            fontFamily: "Poppins",
            fontSize: 19,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          widget.settingType,
          style: Theme.of(context)
              .textTheme
              .subtitle1!
              .copyWith(color: kAccentTransparent),
        ),
      ],
    );
  }
}
