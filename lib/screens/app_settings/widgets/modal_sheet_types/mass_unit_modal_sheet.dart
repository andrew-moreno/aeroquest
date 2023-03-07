import 'package:aeroquest/providers/app_settings_provider.dart';
import 'package:aeroquest/screens/app_settings/widgets/app_settings_modal_sheet.dart';
import 'package:aeroquest/screens/app_settings/widgets/setting_types/mass_unit_setting.dart';
import 'package:aeroquest/widgets/animated_toggle.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class MassUnitModalSheet extends StatefulWidget {
  /// Defines the modal sheet used for editing the grind setting interval
  const MassUnitModalSheet({
    Key? key,
    required this.initialMassUnit,
  }) : super(key: key);

  /// Initial value of the grind interval to display in the modal sheet
  final MassUnit initialMassUnit;

  @override
  State<MassUnitModalSheet> createState() => _MassUnitModalSheetState();
}

class _MassUnitModalSheetState extends State<MassUnitModalSheet> {
  @override
  void initState() {
    super.initState();
    Provider.of<AppSettingsProvider>(context, listen: false).tempMassUnit =
        widget.initialMassUnit;
  }

  @override
  Widget build(BuildContext context) {
    return AppSettingsModalSheet(
      text: "Temperature unit selection:",
      editor: MassUnitSetting(
        initialMassUnit: widget.initialMassUnit,
        toggleType: ToggleType.horizontal,
      ),
      onSave: () {
        Provider.of<AppSettingsProvider>(context, listen: false).updateMassUnit(
            describeEnum(
                Provider.of<AppSettingsProvider>(context, listen: false)
                    .tempMassUnit!));
        Navigator.of(context).pop();
      },
    );
  }
}
