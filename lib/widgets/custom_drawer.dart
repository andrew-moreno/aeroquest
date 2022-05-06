import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/screens/about_aeroquest/about_aeroquest.dart';
import 'package:aeroquest/screens/coffee_beans/coffee_beans.dart';
import 'package:aeroquest/screens/recipes/recipes.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Column(
            children: [
              Text(
                "AEROQUEST",
                style: Theme.of(context).textTheme.headline1!,
              ),
              const Divider(
                color: Color(0x00000000),
                thickness: 0,
                height: 15,
              ),
              _menuItemBuilder(
                ctx: context,
                icon: const Icon(Icons.coffee_rounded, size: 23),
                route: Recipes.routeName,
                text: "Recipes",
                isAbout: false,
              ),
              _menuItemBuilder(
                ctx: context,
                icon: Image.asset("assets/images/coffee_bean.png",
                    scale: 25, color: kLightSecondary),
                route: CoffeeBeans.routeName,
                text: "Coffee Beans",
                isAbout: false,
              ),
              const Spacer(),
              _menuItemBuilder(
                ctx: context,
                icon: const Icon(Icons.info_outline, size: 23),
                route: AboutAeroquest.routeName,
                text: "About AEROQUEST",
                isAbout: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  ListTile _menuItemBuilder({
    required BuildContext ctx,
    required Widget icon,
    required String route,
    required String text,
    required bool isAbout,
  }) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      onTap: () {
        Navigator.of(ctx).pop();

        if (route != ModalRoute.of(ctx)!.settings.name) {
          if (route == Recipes.routeName) {
            Navigator.of(ctx).pushNamedAndRemoveUntil(
                route, (Route<dynamic> route) => false);
          } else {
            Navigator.of(ctx).pushNamed(route);
          }
        }
      },
      horizontalTitleGap: 0,
      iconColor: (isAbout) ? kAccent : kLightSecondary,
      leading: icon,
      title: Text(
        text,
        style: TextStyle(
          color: (isAbout) ? kAccent : kLightSecondary,
          fontFamily: "Poppins",
          fontSize: 17,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
