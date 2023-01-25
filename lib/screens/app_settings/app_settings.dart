import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/providers/app_settings_provider.dart';
import 'package:aeroquest/screens/app_settings/widgets/modal_sheet_types/grind_interval_modal_sheet.dart';
import 'package:aeroquest/screens/app_settings/widgets/modal_sheet_types/temperature_modal_sheet.dart';
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
  void showTemperatureModalSheet({required BuildContext context}) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(kModalCornerRadius)),
      ),
      backgroundColor: kDarkSecondary,
      isScrollControlled: true,
      builder: (_) {
        return TemperatureModalSheet(
            initialTemperatureUnit:
                Provider.of<AppSettingsProvider>(context, listen: false)
                    .temperatureUnit!);
      },
    );
  }

  String temperatureUnitSymbolSelector(TemperatureUnit temperatureUnit) {
    switch (temperatureUnit) {
      case TemperatureUnit.celsius:
        return "°C";
      case TemperatureUnit.fahrenheit:
        return "°F";
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
              Consumer<AppSettingsProvider>(
                //TODO: make changes specific to variable
                builder: (_, appSettingsProvider, __) {
                  return SettingCard(
                      text: appSettingsProvider.grindInterval!.toString(),
                      onTap: () =>
                          showGrindIntervalModalSheet(context: context),
                      title: "Grind Size Interval",
                      description: "Defines the amount that "
                          "the grind size setting for a recipe "
                          "can be increased or decreased");
                },
              ),
              const SizedBox(height: 20),
              Consumer<AppSettingsProvider>(
                //TODO: make changes specific to variable
                builder: (_, appSettingsProvider, __) {
                  return SettingCard(
                      text: temperatureUnitSymbolSelector(
                          appSettingsProvider.temperatureUnit!),
                      onTap: () => showTemperatureModalSheet(context: context),
                      title: "Temperature Unit",
                      description: "Whether to use Celsius or Fahrenheit for "
                          "the temperature setting for a recipe");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
