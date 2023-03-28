import 'package:aeroquest/providers/app_settings_provider.dart';
import 'package:aeroquest/screens/app_settings/widgets/app_settings_modal_sheet.dart';
import 'package:aeroquest/screens/app_settings/widgets/setting_types/temperature_unit_setting.dart';
import 'package:aeroquest/widgets/animated_toggle.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class TemperatureUnitModalSheet extends StatefulWidget {
  /// Defines the modal sheet used for editing the temperature unit setting
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
  @override
  void initState() {
    super.initState();
    Provider.of<AppSettingsProvider>(context, listen: false)
        .tempTemperatureUnit = widget.initialTemperatureUnit;
  }

  @override
  Widget build(BuildContext context) {
    return AppSettingsModalSheet(
      text: "Temperature unit selection:",
      editor: TemperatureUnitSetting(
        initialTemperatureUnit: widget.initialTemperatureUnit,
        toggleType: ToggleType.horizontal,
      ),
      onSave: () {
        Provider.of<AppSettingsProvider>(context, listen: false)
            .updateTemperatureUnit(describeEnum(
                Provider.of<AppSettingsProvider>(context, listen: false)
                    .tempTemperatureUnit!));
        Navigator.of(context).pop();
      },
    );
  }
}
