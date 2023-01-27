import 'package:aeroquest/providers/app_settings_provider.dart';
import 'package:aeroquest/screens/app_settings/widgets/app_settings_modal_sheet.dart';
import 'package:aeroquest/widgets/custom_modal_sheet/modal_value_container.dart';
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
  /// Temporary grind interval value that is used to select a value in the
  /// modal sheet without saving to the Shared Preferences db
  late double _tempGrindInterval;

  /// Possible grind interval values that can be set
  static const List<double> _intervalValues = [0.1, 0.2, 0.25, 1 / 3, 0.5, 1.0];

  @override
  void initState() {
    super.initState();
    _tempGrindInterval = widget.initialGrindInterval;
  }

  @override
  Widget build(BuildContext context) {
    return AppSettingsModalSheet(
      text: "Grind size interval selection:",
      editor: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (int index = 0; index < _intervalValues.length; index++)
            ModalValueContainer(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 7,
                  vertical: 10,
                ),
                child: Text(
                  AppSettingsProvider.getGrindIntervalText(
                      _intervalValues[index]),
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              onTap: () {
                setState(() {
                  _tempGrindInterval = _intervalValues[index];
                });
              },
              displayBorder: _tempGrindInterval == _intervalValues[index],
            )
        ],
      ),
      onTap: () {
        Provider.of<AppSettingsProvider>(context, listen: false)
            .updateGrindInterval(_tempGrindInterval);
        Navigator.of(context).pop();
      },
    );
  }
}
