import 'package:flutter/material.dart';
import 'package:aeroquest/constraints.dart';

// defines the template for displaying recipe information values
// eg. grind: 17
class SettingsValue extends StatefulWidget {
  const SettingsValue({
    Key? key,
    required this.settingValue,
    required this.settingType,
  }) : super(key: key);

  // can be int or double
  final dynamic settingValue;
  final SettingType settingType;

  @override
  State<SettingsValue> createState() => _SettingsValueState();
}

class _SettingsValueState extends State<SettingsValue> {
  /// defines default values and whether grams is added to the end or not
  String _settingValue(SettingType settingType) {
    switch (settingType) {
      case SettingType.grindSetting: // double
        return widget.settingValue.toString();
      case SettingType.coffeeAmount: // double
        return (widget.settingValue).toString() + "g";
      case SettingType.waterAmount: // int
        return (widget.settingValue).toString() + "g";
      case SettingType.waterTemp: // int
        return widget.settingValue.toString();
      case SettingType.brewTime: // int
        return (widget.settingValue ~/ 6).toString() +
            ":" +
            (widget.settingValue % 6).toString() +
            "0";
      case SettingType.none:
        throw Exception("SettingType.none passed incorrectly");
    }
  }

  /// defines text used for settings value display
  String _settingType(SettingType settingType) {
    switch (settingType) {
      case SettingType.grindSetting:
        return "Grind";
      case SettingType.coffeeAmount:
        return "Coffee";
      case SettingType.waterAmount:
        return "Water";
      case SettingType.waterTemp:
        return "Temp";
      case SettingType.brewTime:
        return "Time";
      case SettingType.none:
        throw Exception("SettingType.none passed incorrectly");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          _settingValue(widget.settingType),
          style: const TextStyle(
            color: kAccent,
            fontFamily: "Poppins",
            fontSize: 19,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          _settingType(widget.settingType),
          style: Theme.of(context)
              .textTheme
              .subtitle1!
              .copyWith(color: kAccentTransparent),
        ),
      ],
    );
  }
}

/// all types of settings for a recipe
enum SettingType {
  grindSetting,
  coffeeAmount,
  waterAmount,
  waterTemp,
  brewTime,
  none
}
