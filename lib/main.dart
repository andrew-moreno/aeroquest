import 'package:aeroquest/home.dart';
import 'package:aeroquest/providers/app_settings_provider.dart';
import 'package:aeroquest/providers/variables_slider_provider.dart';
import 'package:aeroquest/screens/app_settings/app_settings.dart';
import 'package:aeroquest/screens/onboarding/onboarding.dart';
import 'package:aeroquest/providers/coffee_bean_provider.dart';
import 'package:aeroquest/providers/recipes_provider.dart';
import 'package:aeroquest/screens/coffee_beans/coffee_beans.dart';
import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/screens/recipes/recipes.dart';

import 'package:control_style/decorated_input_border.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RecipesProvider>(
          create: (_) => RecipesProvider(),
        ),
        ChangeNotifierProvider<CoffeeBeanProvider>(
          create: (_) => CoffeeBeanProvider(),
        ),
        ChangeNotifierProvider<VariablesSliderProvider>(
          create: (_) => VariablesSliderProvider(),
        ),
        ChangeNotifierProvider<AppSettingsProvider>(
            create: (_) => AppSettingsProvider()),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp(
            theme: ThemeData(
              useMaterial3: true,
              appBarTheme: const AppBarTheme(
                surfaceTintColor: kPrimary,
                backgroundColor: kPrimary,
                centerTitle: true,
                shadowColor: Colors.black,
              ),
              scaffoldBackgroundColor: kPrimary,
              snackBarTheme: const SnackBarThemeData(
                contentTextStyle: TextStyle(fontFamily: "Poppins"),
              ),
              textTheme: const TextTheme(
                headline1: TextStyle(
                  color: kLightSecondary,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Spectral",
                ),
                headline2: TextStyle(
                  color: kLightSecondary,
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Spectral",
                ),
                headline3: TextStyle(
                  color: kLightSecondary,
                  fontFamily: "Spectral",
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                ),
                headline4: TextStyle(
                  color: kPrimary,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                  fontSize: 25,
                ),
                subtitle1: TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
                subtitle2: TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                bodyText1: TextStyle(
                  color: kAccent,
                  fontFamily: "Poppins",
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                bodyText2: TextStyle(
                  color: kAccent,
                  fontFamily: "Poppins",
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: kInputDecorationHorizontalPadding,
                ),
                hintStyle: const TextStyle(
                  color: kPrimary,
                  fontFamily: "Poppins",
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                errorStyle: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(color: kDeleteRed),
                errorMaxLines: 2,
                filled: true,
                fillColor: kLightSecondary,
                border: DecoratedInputBorder(
                  shadow: [kBoxShadow],
                  child: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(kCornerRadius),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            home: const Home(),
            onGenerateRoute: (settings) {
              if (settings.name == Recipes.routeName) {
                return PageRouteBuilder(
                  settings: settings,
                  pageBuilder: (_, __, ___) => const Recipes(),
                  transitionsBuilder: (_, animation, __, child) =>
                      FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                );
              }
              if (settings.name == CoffeeBeans.routeName) {
                return PageRouteBuilder(
                  settings: settings,
                  pageBuilder: (_, __, ___) => const CoffeeBeans(),
                  transitionsBuilder: (_, animation, __, child) =>
                      FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                );
              }
              if (settings.name == AppSettings.routeName) {
                return PageRouteBuilder(
                  settings: settings,
                  pageBuilder: (_, __, ___) => const AppSettings(),
                  transitionsBuilder: (_, animation, __, child) =>
                      FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                );
              }
              return null;
            },
            routes: {
              Onboarding.routeName: (ctx) => Onboarding(),
            },
          );
        },
      ),
    );
  }
}
