import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/models/recipe_entry.dart';
import 'package:flutter/material.dart';

import '../../../widgets/card_header.dart';
import 'recipe_card/recipe_settings.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({
    Key? key,
    required title,
    required description,
    required coffee,
  })  : _title = title,
        _description = description,
        _coffee = coffee,
        super(key: key);

  final String _title;
  final String _description;
  final List<CoffeeSetting> _coffee;

  static const double verticalPadding = 7;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: verticalPadding,
        horizontal: 15,
      ),
      decoration: BoxDecoration(
        color: kPrimary,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [kBoxShadow],
      ),
      child: Column(
        children: [
          CardHeader(
            title: _title,
            description: _description,
          ),
          const Divider(
            color: Color(0x00000000),
            height: 10,
          ),
          RecipeSettings(
            coffee: _coffee,
            verticalPadding: verticalPadding,
          ),
        ],
      ),
    );
  }
}
