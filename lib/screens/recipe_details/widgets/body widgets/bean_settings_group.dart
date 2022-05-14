import 'package:flutter/material.dart';

import 'package:aeroquest/models/recipe_entry.dart';
import 'package:aeroquest/widgets/recipe_settings/widgets/bean_settings.dart';

class BeanSettingsGroup extends StatelessWidget {
  const BeanSettingsGroup({
    Key? key,
    required recipeData,
  })  : _recipeData = recipeData,
        super(key: key);

  final RecipeEntry _recipeData;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: _recipeData.coffeeSettings.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return BeanSettings(
          coffeeSetting: _recipeData.coffeeSettings[index],
        );
      },
      separatorBuilder: (context, index) {
        return const Divider(
          color: Color(0x00000000),
          height: 10,
        );
      },
    );
  }
}
