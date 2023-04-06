import 'package:aeroquest/providers/app_settings_provider.dart';
import 'package:aeroquest/screens/app_settings/widgets/app_settings_modal_sheet.dart';
import 'package:aeroquest/screens/app_settings/widgets/setting_types/water_unit_setting.dart';
import 'package:aeroquest/widgets/animated_toggle.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class WaterUnitModalSheet extends StatefulWidget {
  /// Defines the modal sheet used for editing the water amount unit setting
  const WaterUnitModalSheet({
    Key? key,
    required this.initialWaterUnit,
  }) : super(key: key);

  /// Initial value of the water unit to display in the modal sheet
  final WaterUnit initialWaterUnit;

  @override
  State<WaterUnitModalSheet> createState() => _WaterUnitModalSheetState();
}

class _WaterUnitModalSheetState extends State<WaterUnitModalSheet> {
  @override
  void initState() {
    super.initState();
    Provider.of<AppSettingsProvider>(context, listen: false).tempWaterUnit =
        widget.initialWaterUnit;
  }

  @override
  Widget build(BuildContext context) {
    return AppSettingsModalSheet(
      text: "Water unit selection:",
      editor: WaterUnitSetting(
        initialWaterUnit: widget.initialWaterUnit,
        toggleType: ToggleType.horizontal,
      ),
      onSave: () {
        Provider.of<AppSettingsProvider>(context, listen: false)
            .updateWaterUnit(describeEnum(
                Provider.of<AppSettingsProvider>(context, listen: false)
                    .tempWaterUnit!));
        Navigator.of(context).pop();
      },
    );
  }
}
