import 'package:aeroquest/models/recipes_provider.dart';
import 'package:flutter/material.dart';

import 'package:aeroquest/constraints.dart';
import 'package:provider/provider.dart';

class AppBarButton extends StatelessWidget {
  AppBarButton({Key? key, required onTap, required icon})
      : _onTap = onTap,
        _icon = icon,
        super(key: key);

  final Function()? _onTap;
  final IconData _icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10, right: 15),
      child:
          Consumer<RecipesProvider>(builder: (builderContext, recipes, child) {
        return InkWell(
          onTap: _onTap,
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
              _icon,
              color: (recipes.editMode == EditMode.enabled)
                  ? kLightSecondary
                  : kAccent,
            ),
          ),
        );
      }),
    );
  }
}
