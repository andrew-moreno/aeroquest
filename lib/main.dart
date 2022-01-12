import 'package:aeroquest/screens/about_aeroquest/about_aeroquest.dart';
import 'package:aeroquest/screens/coffee_beans/coffee_beans.dart';
import 'package:aeroquest/screens/new_recipe/new_recipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'constraints.dart';
import 'screens/recipes/recipes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(392.73, 759.27),
      builder: () => MaterialApp(
        theme: ThemeData(
          backgroundColor: kBackgroundColor,
          canvasColor: kBackgroundColor,
          textTheme: const TextTheme(
            headline1: TextStyle(
              color: kTextColor,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              fontFamily: "Spectral",
            ),
            headline2: TextStyle(
              color: kTextColor,
              fontSize: 27,
              fontWeight: FontWeight.bold,
              fontFamily: "Spectral",
            ),
            subtitle1: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
        initialRoute: Recipes.routeName,
        routes: {
          Recipes.routeName: (ctx) => Recipes(),
          NewRecipe.routeName: (ctx) => NewRecipe(),
          CoffeeBeans.routeName: (ctx) => CoffeeBeans(),
          AboutAeroquest.routeName: (ctx) => AboutAeroquest(),
        },
      ),
    );
  }
}
