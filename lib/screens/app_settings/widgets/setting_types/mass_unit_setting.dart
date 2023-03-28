import 'package:aeroquest/providers/app_settings_provider.dart';
import 'package:aeroquest/widgets/animated_toggle.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class MassUnitSetting extends StatefulWidget {
  /// Defines the modal sheet used for editing the mass unit setting
  const MassUnitSetting({
    Key? key,
    required this.initialMassUnit,
    required this.toggleType,
  }) : super(key: key);

  /// Initial value of the grind interval to display in the modal sheet
  final MassUnit initialMassUnit;

  /// Whether to set the toggle to horizontal or vertical orientation
  final ToggleType toggleType;

  @override
  State<MassUnitSetting> createState() => _MassUnitSettingState();
}

class _MassUnitSettingState extends State<MassUnitSetting> {
  static const _massUnitValues = ["g", "oz"];

  @override
  void initState() {
    super.initState();
    Provider.of<AppSettingsProvider>(context, listen: false).tempMassUnit =
        widget.initialMassUnit;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedToggle(
      values: _massUnitValues,
      onToggleCallback: (index) {
        index == 0
            ? Provider.of<AppSettingsProvider>(context, listen: false)
                .tempMassUnit = MassUnit.gram
            : Provider.of<AppSettingsProvider>(context, listen: false)
                .tempMassUnit = MassUnit.ounce;
      },
      initialPosition: (widget.initialMassUnit == MassUnit.gram)
          ? Position.first
          : Position.last,
      toggleType: widget.toggleType,
    );
  }
}
