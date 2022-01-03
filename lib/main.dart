import 'package:aeroquest/screens/new_recipe/new_recipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'constraints.dart';
import 'screens/recipes_home/recipes_home.dart';

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
            subtitle1: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
        home: RecipesHome(),
        routes: {
          NewRecipe.routeName: (ctx) => NewRecipe(),
        },
      ),
    );
  }
}
