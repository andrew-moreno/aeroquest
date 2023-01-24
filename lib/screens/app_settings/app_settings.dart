import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/providers/app_settings_provider.dart';
import 'package:aeroquest/screens/app_settings/widgets/grind_interval_modal_sheet.dart';
import 'package:aeroquest/widgets/appbar/appbar_leading.dart';
import 'package:aeroquest/widgets/appbar/appbar_text.dart';
import 'package:aeroquest/widgets/card_header.dart';
import 'package:aeroquest/widgets/custom_card.dart';
import 'package:aeroquest/widgets/custom_drawer.dart';
import 'package:aeroquest/widgets/recipe_parameters_value.dart';
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
        child: FutureBuilder(
          future: Provider.of<AppSettingsProvider>(context, listen: false)
              .setGrindInterval(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Padding(
                padding: const EdgeInsets.all(kRoutePagePadding),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () =>
                          showCustomIntervalModalSheet(context: context),
                      child: CustomCard(
                        child: Consumer<AppSettingsProvider>(
                          builder: (_, appSettingsProvider, __) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                  child: CardHeader(
                                    title: "Grind Size Interval",
                                    description:
                                        "Defines the interval for adjusting the "
                                        "grind size for a recipe setting",
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 15),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 15),
                                  decoration: BoxDecoration(
                                    color: kLightSecondary,
                                    borderRadius:
                                        BorderRadius.circular(kCornerRadius),
                                    boxShadow: [kBoxShadow],
                                  ),
                                  child: RecipeParameterValue(
                                    parameterValue:
                                        appSettingsProvider.grindInterval!,
                                    parameterType: ParameterType.none,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}

/// Template for the modal bottom sheet when changing grind size interval
void showCustomIntervalModalSheet({required BuildContext context}) {
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
