import 'package:aeroquest/screens/app_settings/app_settings.dart';
import 'package:flutter/material.dart';

import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/screens/about_aeroquest/about_aeroquest.dart';
import 'package:aeroquest/screens/coffee_beans/coffee_beans.dart';
import 'package:aeroquest/screens/recipes/recipes.dart';

class CustomDrawer extends StatelessWidget {
  /// Defines the drawer to be used in the app
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: kPrimary,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Column(
            children: [
              Text(
                "AEROQUEST",
                style: Theme.of(context).textTheme.headline1!,
              ),
              const SizedBox(
                height: 15,
              ),
              const MenuItem(
                icon: Icon(
                  Icons.coffee_rounded,
                  size: 23,
                ),
                route: Recipes.routeName,
                text: "Recipes",
              ),
              MenuItem(
                icon: Image.asset(
                  "assets/images/coffee_bean.png",
                  scale: 26,
                  color: kLightSecondary,
                ),
                route: CoffeeBeans.routeName,
                text: "Coffee Beans",
              ),
              const MenuItem(
                icon: Icon(
                  Icons.settings,
                  size: 23,
                ),
                text: "Settings",
                route: AppSettings.routeName,
              ),
              const Spacer(),
              const MenuItem(
                icon: Icon(
                  Icons.info_outline,
                  size: 23,
                ),
                route: AboutAeroquest.routeName,
                text: "About AEROQUEST",
                isBottom: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  /// Defines the widget used for a menu item in the drawer
  const MenuItem({
    Key? key,
    required this.icon,
    required this.route,
    required this.text,
    this.isBottom = false,
  }) : super(key: key);

  /// Leading icon to display in the list tile
  final Widget icon;

  /// Route to push when list tile is pressed
  final String route;

  /// Text to display in the list tile
  final String text;

  /// Whether or not the list tile is at the bottom of the drawer or not
  ///
  /// Setting to true will style the list tile differently
  final bool isBottom;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      onTap: () {
        Navigator.of(context).pop();

        if (route != ModalRoute.of(context)!.settings.name) {
          if (route == Recipes.routeName) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                route, (Route<dynamic> route) => false);
          } else {
            Navigator.of(context).pushNamed(route);
          }
        }
      },
      horizontalTitleGap: 0,
      iconColor: (isBottom) ? kAccent : kLightSecondary,
      leading: icon,
      title: Text(
        text,
        style: TextStyle(
          color: (isBottom) ? kAccent : kLightSecondary,
          fontFamily: "Poppins",
          fontSize: (isBottom) ? 18 : 17,
          fontWeight: (isBottom) ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
    );
  }
}
