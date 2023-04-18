import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/providers/recipes_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppBarButton extends StatelessWidget {
  /// Defines the widget used for buttons in the app bar
  const AppBarButton({
    Key? key,
    required this.onTap,
    this.hasDynamicColour = false,
    required this.icon,
  }) : super(key: key);

  /// Function to execute when the button is pressed
  final Function() onTap;

  /// Icon to be displayed in the button
  final IconData icon;

  /// Whether the button will change colour depending on the edit mode or not
  final bool hasDynamicColour;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10, right: 15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(7),
        child: Ink(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: (hasDynamicColour)
                ? (Provider.of<RecipesProvider>(context, listen: false)
                            .editMode ==
                        EditMode.enabled)
                    ? kAccent
                    : kLightSecondary
                : kLightSecondary,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Icon(
            icon,
            color: (hasDynamicColour)
                ? (Provider.of<RecipesProvider>(context, listen: false)
                            .editMode ==
                        EditMode.enabled)
                    ? kLightSecondary
                    : kAccent
                : kAccent,
          ),
        ),
      ),
    );
  }
}
