import 'package:aeroquest/providers/app_settings_provider.dart';
import 'package:aeroquest/widgets/animated_toggle.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WaterUnitSetting extends StatefulWidget {
  /// Defines the modal sheet used for editing the water amount unit setting
  const WaterUnitSetting({
    Key? key,
    required this.initialWaterUnit,
    required this.toggleType,
  }) : super(key: key);

  /// Initial value of the water unit to display in the modal sheet
  final WaterUnit initialWaterUnit;

  /// Whether to set the toggle to horizontal or vertical orientation
  final ToggleType toggleType;

  static const Map<WaterUnit, String> waterUnitValues = {
    WaterUnit.gram: "g",
    WaterUnit.ounce: "oz",
  };

  @override
  State<WaterUnitSetting> createState() => _WaterUnitSettingState();
}

class _WaterUnitSettingState extends State<WaterUnitSetting> {
  @override
  void initState() {
    super.initState();
    Provider.of<AppSettingsProvider>(context, listen: false).tempWaterUnit =
        widget.initialWaterUnit;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedToggle(
      values: WaterUnitSetting.waterUnitValues.values.toList(),
      onToggleCallback: (index) {
        index == 0
            ? Provider.of<AppSettingsProvider>(context, listen: false)
                .tempWaterUnit = WaterUnit.gram
            : Provider.of<AppSettingsProvider>(context, listen: false)
                .tempWaterUnit = WaterUnit.ounce;
      },
      initialPosition: (widget.initialWaterUnit == WaterUnit.gram)
          ? Position.first
          : Position.last,
      toggleType: widget.toggleType,
    );
  }
}
