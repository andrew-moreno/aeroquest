import 'package:flutter/material.dart';

import '../../../constraints.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: kBackgroundColor,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Scaffold.of(context).openDrawer(),
        icon: const Icon(
          Icons.menu,
          color: kTextColor,
          size: 30,
        ),
      ),
      title: const Text(
        "AEROQUEST",
        style: TextStyle(
          color: kTextColor,
          fontSize: 27,
          fontWeight: FontWeight.bold,
          fontFamily: "Spectral",
        ),
      ),
      centerTitle: true,
      actions: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(
                "/newRecipe",
              );
            },
            borderRadius: BorderRadius.circular(7),
            child: Ink(
              decoration: BoxDecoration(
                color: kLightNavy,
                borderRadius: BorderRadius.circular(7),
              ),
              child: const Icon(
                Icons.add,
                color: kAccentYellow,
                size: 35,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
