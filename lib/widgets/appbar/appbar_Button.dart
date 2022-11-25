import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/providers/recipes_provider.dart';

class AppBarButton extends StatelessWidget {
  /// Defines the widget used for buttons in the app bar
  const AppBarButton({
    Key? key,
    required this.onTap,
    required this.icon,
  }) : super(key: key);

  /// Function to execute when the button is pressed
  final Function() onTap;

  /// Icon to be displayed in the icon
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10, right: 15),
      child: Consumer<RecipesProvider>(
        builder: (builderContext, recipes, child) {
          return InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(7),
            child: Ink(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: (recipes.editMode == EditMode.enabled)
                    ? kAccent
                    : kLightSecondary,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Icon(
                icon,
                color: (recipes.editMode == EditMode.enabled)
                    ? kLightSecondary
                    : kAccent,
              ),
            ),
          );
        },
      ),
    );
  }
}
