import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/providers/app_settings_provider.dart';
import 'package:aeroquest/screens/app_settings/widgets/modal_sheet_types/grind_interval_modal_sheet.dart';
import 'package:aeroquest/screens/app_settings/widgets/modal_sheet_types/mass_unit_modal_sheet.dart';
import 'package:aeroquest/screens/app_settings/widgets/modal_sheet_types/temperature_unit_modal_sheet.dart';
import 'package:aeroquest/screens/app_settings/widgets/setting_card.dart';
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
  /// Template for the modal bottom sheet when changing grind size interval
  void showGrindIntervalModalSheet({required BuildContext context}) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(kModalCornerRadius)),
      ),
      backgroundColor: kDarkSecondary,
      isScrollControlled: true,
      builder: (_) {
        return GrindIntervalModalSheet(
          initialGrindInterval:
              Provider.of<AppSettingsProvider>(context, listen: false)
                  .grindInterval!,
        );
      },
    );
  }

  /// Template for the modal bottom sheet when changing the temperature unit
  void showTemperatureUnitModalSheet({required BuildContext context}) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(kModalCornerRadius)),
      ),
      backgroundColor: kDarkSecondary,
      isScrollControlled: true,
      builder: (_) {
        return TemperatureUnitModalSheet(
            initialTemperatureUnit:
                Provider.of<AppSettingsProvider>(context, listen: false)
                    .temperatureUnit!);
      },
    );
  }

  /// Template for the modal bottom sheet when changing the mass unit
  void showMassUnitModalSheet({required BuildContext context}) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(kModalCornerRadius)),
      ),
      backgroundColor: kDarkSecondary,
      isScrollControlled: true,
      builder: (_) {
        return MassUnitModalSheet(
            initialMassUnit:
                Provider.of<AppSettingsProvider>(context, listen: false)
                    .massUnit!);
      },
    );
  }

  /// Selects the correct temperature unit text to return based on the
  /// [tempUnit]
  String _temperatureUnitTextSelector(TemperatureUnit tempUnit) {
    switch (tempUnit) {
      case TemperatureUnit.celsius:
        return "°C";
      case TemperatureUnit.fahrenheit:
        return "°F";
    }
  }

  /// Selects the correct mass unit text to return based on the [massUnit]
  String _massUnitTextSelector(MassUnit massUnit) {
    switch (massUnit) {
      case MassUnit.gram:
        return "g";
      case MassUnit.ounce:
        return "oz";
    }
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
        child: Padding(
          padding: const EdgeInsets.all(kRoutePagePadding),
          child: Column(
            children: [
              Selector<AppSettingsProvider, double>(
                selector: (_, provider) => provider.grindInterval!,
                builder: (_, grindInterval, __) {
                  return SettingCard(
                      text: AppSettingsProvider.getGrindIntervalText(
                          grindInterval),
                      onTap: () =>
                          showGrindIntervalModalSheet(context: context),
                      title: "Grind Size Interval",
                      description: "Defines the amount that "
                          "the grind size setting for a recipe "
                          "can be increased or decreased");
                },
              ),
              const SizedBox(height: 20),
              Selector<AppSettingsProvider, TemperatureUnit>(
                selector: (_, provider) => provider.temperatureUnit!,
                builder: (_, temperatureUnit, __) {
                  return SettingCard(
                      text: _temperatureUnitTextSelector(temperatureUnit),
                      onTap: () =>
                          showTemperatureUnitModalSheet(context: context),
                      title: "Temperature Unit",
                      description: "Whether to use Celsius or Fahrenheit for "
                          "the temperature setting for a recipe");
                },
              ),
              const SizedBox(height: 20),
              Selector<AppSettingsProvider, MassUnit>(
                selector: (_, provider) => provider.massUnit!,
                builder: (_, massUnit, __) {
                  return SettingCard(
                      text: _massUnitTextSelector(massUnit),
                      onTap: () => showMassUnitModalSheet(context: context),
                      title: "Mass Unit",
                      description: "Whether to use grams or ounces for "
                          "the mass setting for a recipe");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}