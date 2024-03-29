import 'package:aeroquest/providers/app_settings_provider.dart';
import 'package:aeroquest/widgets/animated_toggle.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TemperatureUnitSetting extends StatefulWidget {
  /// Defines the modal sheet used for editing the temperature unit setting
  const TemperatureUnitSetting({
    Key? key,
    required this.initialTemperatureUnit,
    required this.toggleType,
  }) : super(key: key);

  /// Initial value of the temperature unit to display in the modal sheet
  final TemperatureUnit initialTemperatureUnit;

  /// Whether to set the toggle to horizontal or vertical orientation
  final ToggleType toggleType;

  static const temperatureUnitValues = ["°C", "°F"];

  @override
  State<TemperatureUnitSetting> createState() => _TemperatureUnitSettingState();
}

class _TemperatureUnitSettingState extends State<TemperatureUnitSetting> {
  @override
  void initState() {
    super.initState();
    Provider.of<AppSettingsProvider>(context, listen: false)
        .tempTemperatureUnit = widget.initialTemperatureUnit;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedToggle(
      values: TemperatureUnitSetting.temperatureUnitValues,
      onToggleCallback: (index) {
        index == 0
            ? Provider.of<AppSettingsProvider>(context, listen: false)
                .tempTemperatureUnit = TemperatureUnit.celsius
            : Provider.of<AppSettingsProvider>(context, listen: false)
                .tempTemperatureUnit = TemperatureUnit.fahrenheit;
      },
      initialPosition:
          (widget.initialTemperatureUnit == TemperatureUnit.celsius)
              ? Position.first
              : Position.last,
      toggleType: widget.toggleType,
    );
  }
}
