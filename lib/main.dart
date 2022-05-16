import 'package:aeroquest/models/recipes_provider.dart';
import 'package:control_style/decorated_input_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:aeroquest/screens/about_aeroquest/about_aeroquest.dart';
import 'package:aeroquest/screens/coffee_beans/coffee_beans.dart';
import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/screens/recipes/recipes.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RecipesProvider(),
      builder: (context, child) {
        return MaterialApp(
          theme: ThemeData(
            useMaterial3: true,
            backgroundColor: kPrimary,
            canvasColor: kPrimary,
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
            ),
          ),
          initialRoute: Recipes.routeName,
          onGenerateRoute: (settings) {
            if (settings.name == Recipes.routeName) {
              return PageRouteBuilder(
                  settings:
                      settings, // Pass this to make popUntil(), pushNamedAndRemoveUntil(), works
                  pageBuilder: (_, __, ___) => Recipes(),
                  transitionsBuilder: (_, a, __, c) =>
                      FadeTransition(opacity: a, child: c));
            }
            if (settings.name == CoffeeBeans.routeName) {
              return PageRouteBuilder(
                  settings:
                      settings, // Pass this to make popUntil(), pushNamedAndRemoveUntil(), works
                  pageBuilder: (_, __, ___) => const CoffeeBeans(),
                  transitionsBuilder: (_, animation, __, child) =>
                      FadeTransition(opacity: animation, child: child));
            }
          },
          routes: {
            AboutAeroquest.routeName: (ctx) => const AboutAeroquest(),
          },
        );
      },
    );
  }
}
