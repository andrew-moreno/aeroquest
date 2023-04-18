import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/providers/app_settings_provider.dart';
import 'package:aeroquest/screens/app_settings/widgets/modal_sheet_types/coffee_unit_modal_sheet.dart';
import 'package:aeroquest/screens/app_settings/widgets/modal_sheet_types/grind_interval_modal_sheet.dart';
import 'package:aeroquest/screens/app_settings/widgets/modal_sheet_types/water_unit_modal_sheet.dart';
import 'package:aeroquest/screens/app_settings/widgets/modal_sheet_types/temperature_unit_modal_sheet.dart';
import 'package:aeroquest/screens/app_settings/widgets/setting_card.dart';
import 'package:aeroquest/screens/app_settings/widgets/setting_types/coffee_unit_setting.dart';
import 'package:aeroquest/screens/app_settings/widgets/setting_types/temperature_unit_setting.dart';
import 'package:aeroquest/screens/app_settings/widgets/setting_types/water_unit_setting.dart';
import 'package:aeroquest/widgets/appbar/appbar_leading.dart';
import 'package:aeroquest/widgets/appbar/appbar_text.dart';
import 'package:aeroquest/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppSettings extends StatefulWidget {
  /// Defines the screen for displaying all app settings
  const AppSettings({Key? key}) : super(key: key);

  static const routeName = "/settings";

  @override
  State<AppSettings> createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  /// Function used to display the bottom modal sheet that holds the setting
  /// widget
  ///
  /// modalContent refers to the settings widget being displayed within the
  /// modal
  void showModalSheet({
    required BuildContext context,
    required Widget modalContent,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(kModalCornerRadius)),
      ),
      backgroundColor: kDarkSecondary,
      isScrollControlled: true,
      builder: (_) {
        return modalContent;
      },
    );
  }

  /// Selects the correct temperature unit text to return based on the
  /// [tempUnit]
  String _temperatureUnitTextSelector(TemperatureUnit tempUnit) {
    switch (tempUnit) {
      case TemperatureUnit.celsius:
        return TemperatureUnitSetting.temperatureUnitValues[0];
      case TemperatureUnit.fahrenheit:
        return TemperatureUnitSetting.temperatureUnitValues[1];
    }
  }

  /// Selects the correct water amount unit text to return based on the
  /// [waterUnit]
  String _waterUnitTextSelector(WaterUnit waterUnit) {
    return WaterUnitSetting.waterUnitValues[waterUnit]!;
  }

  /// Selects the correct coffee amount unit text to return based on the
  /// [coffeeUnit]
  String _coffeeUnitTextSelector(CoffeeUnit coffeeUnit) {
    return CoffeeUnitSetting.coffeeUnitValues[coffeeUnit]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimary,
        elevation: 0,
        centerTitle: true,
        leading: const AppBarLeading(leadingFunction: LeadingFunction.menu),
        title: const AppBarText(text: "SETTINGS"),
      ),
      drawer: const CustomDrawer(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(kRoutePagePadding),
          children: [
            Selector<AppSettingsProvider, double>(
              selector: (_, provider) => provider.grindInterval!,
              builder: (_, grindInterval, __) {
                return SettingCard(
                  text: AppSettingsProvider.getGrindIntervalText(grindInterval),
                  onTap: () => showModalSheet(
                    context: context,
                    modalContent: GrindIntervalModalSheet(
                      initialGrindInterval: Provider.of<AppSettingsProvider>(
                              context,
                              listen: false)
                          .grindInterval!,
                    ),
                  ),
                  title: "Grind Size Interval",
                  description: "Defines the amount that "
                      "the grind size variable for a recipe "
                      "can be increased or decreased",
                );
              },
            ),
            const SizedBox(height: 20),
            Selector<AppSettingsProvider, TemperatureUnit>(
              selector: (_, provider) => provider.temperatureUnit!,
              builder: (_, temperatureUnit, __) {
                return SettingCard(
                  text: _temperatureUnitTextSelector(temperatureUnit),
                  onTap: () => showModalSheet(
                    context: context,
                    modalContent: TemperatureUnitModalSheet(
                        initialTemperatureUnit:
                            Provider.of<AppSettingsProvider>(context,
                                    listen: false)
                                .temperatureUnit!),
                  ),
                  title: "Temperature Unit",
                  description: "Whether to use Celsius or Fahrenheit for "
                      "the temperature variable for a recipe",
                );
              },
            ),
            const SizedBox(height: 20),
            Selector<AppSettingsProvider, WaterUnit>(
              selector: (_, provider) => provider.waterUnit!,
              builder: (_, waterUnit, __) {
                return SettingCard(
                  text: _waterUnitTextSelector(waterUnit),
                  onTap: () => showModalSheet(
                    context: context,
                    modalContent: WaterUnitModalSheet(
                        initialWaterUnit: Provider.of<AppSettingsProvider>(
                                context,
                                listen: false)
                            .waterUnit!),
                  ),
                  title: "Water Amount Unit",
                  description: "Whether to use grams or ounces for "
                      "the amount of water used to brew a recipe",
                );
              },
            ),
            const SizedBox(height: 20),
            Selector<AppSettingsProvider, CoffeeUnit>(
              selector: (_, provider) => provider.coffeeUnit!,
              builder: (_, coffeeUnit, __) {
                return SettingCard(
                  text: _coffeeUnitTextSelector(coffeeUnit),
                  onTap: () => showModalSheet(
                    context: context,
                    modalContent: CoffeeUnitModalSheet(
                        initialCoffeeUnit: Provider.of<AppSettingsProvider>(
                                context,
                                listen: false)
                            .coffeeUnit!),
                  ),
                  title: "Coffee Amount Unit",
                  description: "Whether to use grams, tablespoons, or the "
                      "AeroPress scoop for the amount of coffee used to "
                      "brew a recipe",
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
