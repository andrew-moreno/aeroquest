import 'package:aeroquest/providers/app_settings_provider.dart';
import 'package:aeroquest/widgets/custom_modal_sheet/modal_value_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GrindIntervalSetting extends StatefulWidget {
  /// Defines the modal sheet used for editing the grind setting interval
  const GrindIntervalSetting({Key? key}) : super(key: key);

  static const List<double> intervalValues = [0.1, 0.2, 0.25, 1 / 3, 0.5, 1.0];

  @override
  State<GrindIntervalSetting> createState() => _GrindIntervalSettingState();
}

class _GrindIntervalSettingState extends State<GrindIntervalSetting> {
  /// Possible grind interval values that can be set

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (int index = 0;
            index < GrindIntervalSetting.intervalValues.length;
            index++)
          ModalValueContainer(
            child: Text(
              AppSettingsProvider.getGrindIntervalText(
                  GrindIntervalSetting.intervalValues[index]),
              style: Theme.of(context).textTheme.bodyText1,
            ),
            onTap: () {
              Provider.of<AppSettingsProvider>(context, listen: false)
                      .tempGrindInterval =
                  GrindIntervalSetting.intervalValues[index];
              setState(() {});
            },
            displayBorder:
                Provider.of<AppSettingsProvider>(context, listen: false)
                        .tempGrindInterval ==
                    GrindIntervalSetting.intervalValues[index],
          )
      ],
    );
  }
}
