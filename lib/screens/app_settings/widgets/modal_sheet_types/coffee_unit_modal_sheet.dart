import 'package:aeroquest/providers/app_settings_provider.dart';
import 'package:aeroquest/screens/app_settings/widgets/app_settings_modal_sheet.dart';
import 'package:aeroquest/screens/app_settings/widgets/setting_types/coffee_unit_setting.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class CoffeeUnitModalSheet extends StatefulWidget {
  /// Defines the modal sheet used for editing the coffee amount unit setting
  const CoffeeUnitModalSheet({
    Key? key,
    required this.initialCoffeeUnit,
  }) : super(key: key);

  /// Initial value of the coffee unit to display in the modal sheet
  final CoffeeUnit initialCoffeeUnit;

  @override
  State<CoffeeUnitModalSheet> createState() => _CoffeeUnitModalSheetState();
}

class _CoffeeUnitModalSheetState extends State<CoffeeUnitModalSheet> {
  @override
  void initState() {
    super.initState();
    Provider.of<AppSettingsProvider>(context, listen: false).tempCoffeeUnit =
        widget.initialCoffeeUnit;
  }

  @override
  Widget build(BuildContext context) {
    return AppSettingsModalSheet(
      text: "Coffee unit selection:",
      editor: const CoffeeUnitSetting(),
      onSave: () {
        Provider.of<AppSettingsProvider>(context, listen: false)
            .updateCoffeeUnit(describeEnum(
                Provider.of<AppSettingsProvider>(context, listen: false)
                    .tempCoffeeUnit!));
        Navigator.of(context).pop();
      },
    );
  }
}
