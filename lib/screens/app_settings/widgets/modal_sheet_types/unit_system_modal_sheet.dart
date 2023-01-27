import 'package:aeroquest/providers/app_settings_provider.dart';
import 'package:aeroquest/screens/app_settings/widgets/app_settings_modal_sheet.dart';
import 'package:aeroquest/widgets/animated_toggle.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class UnitSystemModalSheet extends StatefulWidget {
  /// Defines the modal sheet used for editing the grind setting interval
  const UnitSystemModalSheet({
    Key? key,
    required this.initialUnitSystem,
  }) : super(key: key);

  /// Initial value of the grind interval to display in the modal sheet
  final UnitSystem initialUnitSystem;

  @override
  State<UnitSystemModalSheet> createState() => _UnitSystemModalSheetState();
}

class _UnitSystemModalSheetState extends State<UnitSystemModalSheet> {
  late UnitSystem _tempUnitSystem;

  static const _unitSystemValues = ["g/°C", "oz/°F"];

  @override
  void initState() {
    super.initState();
    _tempUnitSystem = widget.initialUnitSystem;
  }

  @override
  Widget build(BuildContext context) {
    return AppSettingsModalSheet(
      text: "Measurement unit selection:",
      editor: AnimatedToggle(
        values: _unitSystemValues,
        onToggleCallback: (index) {
          index == 0
              ? _tempUnitSystem = UnitSystem.metric
              : _tempUnitSystem = UnitSystem.imperial;
        },
        initialPosition: (widget.initialUnitSystem == UnitSystem.metric)
            ? Position.first
            : Position.last,
        toggleType: ToggleType.horizontal,
      ),
      onTap: () {
        Provider.of<AppSettingsProvider>(context, listen: false)
            .updateUnitSystem(describeEnum(_tempUnitSystem));
        Navigator.of(context).pop();
      },
    );
  }
}
