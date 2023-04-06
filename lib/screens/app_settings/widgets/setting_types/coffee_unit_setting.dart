import 'package:aeroquest/providers/app_settings_provider.dart';
import 'package:aeroquest/widgets/custom_modal_sheet/modal_value_container.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class CoffeeUnitSetting extends StatefulWidget {
  /// Defines the modal sheet used for editing the coffee amount unit setting
  const CoffeeUnitSetting({
    Key? key,
  }) : super(key: key);

  static const Map<CoffeeUnit, String> coffeeUnitValues = {
    CoffeeUnit.gram: "g",
    CoffeeUnit.tbps: "tbps",
    CoffeeUnit.scoop: "scps",
  };

  @override
  State<CoffeeUnitSetting> createState() => _CoffeeUnitSettingState();
}

class _CoffeeUnitSettingState extends State<CoffeeUnitSetting> {
  CoffeeUnit stringToCoffeeUnit(String coffeeUnit) {
    if (coffeeUnit == CoffeeUnitSetting.coffeeUnitValues[CoffeeUnit.gram]) {
      return CoffeeUnit.gram;
    } else if (coffeeUnit ==
        CoffeeUnitSetting.coffeeUnitValues[CoffeeUnit.tbps]) {
      return CoffeeUnit.tbps;
    } else if (coffeeUnit ==
        CoffeeUnitSetting.coffeeUnitValues[CoffeeUnit.scoop]) {
      return CoffeeUnit.scoop;
    } else {
      throw Exception("Invalid coffeeUnitValue entry");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int index = 0;
            index < CoffeeUnitSetting.coffeeUnitValues.length;
            index++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ModalValueContainer(
              child: Text(
                CoffeeUnitSetting.coffeeUnitValues.values.elementAt(index),
                style: Theme.of(context).textTheme.bodyText1,
              ),
              onTap: () {
                Provider.of<AppSettingsProvider>(context, listen: false)
                        .tempCoffeeUnit =
                    stringToCoffeeUnit(CoffeeUnitSetting.coffeeUnitValues.values
                        .elementAt(index));
                setState(() {});
              },
              displayBorder:
                  Provider.of<AppSettingsProvider>(context, listen: false)
                          .tempCoffeeUnit ==
                      stringToCoffeeUnit(CoffeeUnitSetting
                          .coffeeUnitValues.values
                          .elementAt(index)),
            ),
          )
      ],
    );
  }
}
