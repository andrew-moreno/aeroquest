import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/providers/app_settings_provider.dart';
import 'package:aeroquest/screens/onboarding/onboarding.dart';
import 'package:aeroquest/screens/recipes/recipes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  static const routeName = "/";

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<Widget> checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool(AppSettingsProvider.isOnboardingSeen) ?? false);

    if (_seen) {
      return const Recipes();
    } else {
      return Onboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkFirstSeen(),
      builder: (context, AsyncSnapshot<Widget> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return snapshot.data!;
        } else {
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: kAccent,
            ),
          );
        }
      },
    );
  }
}
