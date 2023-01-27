import 'package:aeroquest/providers/app_settings_provider.dart';
import 'package:aeroquest/screens/app_settings/widgets/app_settings_modal_sheet.dart';
import 'package:aeroquest/widgets/animated_toggle.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class TemperatureUnitModalSheet extends StatefulWidget {
  /// Defines the modal sheet used for editing the grind setting interval
  const TemperatureUnitModalSheet({
    Key? key,
    required this.initialTemperatureUnit,
  }) : super(key: key);

  /// Initial value of the grind interval to display in the modal sheet
  final TemperatureUnit initialTemperatureUnit;

  @override
  State<TemperatureUnitModalSheet> createState() =>
      _TemperatureUnitModalSheetState();
}

class _TemperatureUnitModalSheetState extends State<TemperatureUnitModalSheet> {
  late TemperatureUnit _tempTemperatureUnit;

  static const _temperatureUnitValues = ["°C", "°F"];

  @override
  void initState() {
    super.initState();
    _tempTemperatureUnit = widget.initialTemperatureUnit;
  }

  @override
  Widget build(BuildContext context) {
    return AppSettingsModalSheet(
      text: "Temperature unit selection:",
      editor: AnimatedToggle(
        values: _temperatureUnitValues,
        onToggleCallback: (index) {
          index == 0
              ? _tempTemperatureUnit = TemperatureUnit.celsius
              : _tempTemperatureUnit = TemperatureUnit.fahrenheit;
        },
        initialPosition:
            (widget.initialTemperatureUnit == TemperatureUnit.celsius)
                ? Position.first
                : Position.last,
        toggleType: ToggleType.horizontal,
      ),
      onTap: () {
        Provider.of<AppSettingsProvider>(context, listen: false)
            .updateTemperatureUnit(describeEnum(_tempTemperatureUnit));
        Navigator.of(context).pop();
      },
    );
  }
}
