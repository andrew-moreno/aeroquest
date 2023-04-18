import 'package:aeroquest/providers/app_settings_provider.dart';
import 'package:aeroquest/screens/app_settings/widgets/app_settings_modal_sheet.dart';
import 'package:aeroquest/screens/app_settings/widgets/setting_types/grind_interval_setting.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GrindIntervalModalSheet extends StatefulWidget {
  /// Defines the modal sheet used for editing the grind setting interval
  const GrindIntervalModalSheet({
    Key? key,
    required this.initialGrindInterval,
  }) : super(key: key);

  /// Initial value of the grind interval to display in the modal sheet
  final double initialGrindInterval;

  @override
  State<GrindIntervalModalSheet> createState() =>
      _GrindIntervalModalSheetState();
}

class _GrindIntervalModalSheetState extends State<GrindIntervalModalSheet> {
  @override
  void initState() {
    super.initState();
    Provider.of<AppSettingsProvider>(context, listen: false).tempGrindInterval =
        widget.initialGrindInterval;
  }

  @override
  Widget build(BuildContext context) {
    return AppSettingsModalSheet(
      text: "Grind size interval selection:",
      editor: const GrindIntervalSetting(),
      onSave: () {
        Provider.of<AppSettingsProvider>(context, listen: false)
            .updateGrindInterval(
                Provider.of<AppSettingsProvider>(context, listen: false)
                    .tempGrindInterval!);
        Navigator.of(context).pop();
      },
    );
  }
}
