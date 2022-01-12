import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/screens/new_recipe/new_recipe.dart';
import 'package:aeroquest/widgets/appbar/appbar_addButton.dart';
import 'package:aeroquest/widgets/appbar/appbar_leading.dart';
import 'package:aeroquest/widgets/appbar/appbar_text.dart';
import 'package:flutter/material.dart';

import 'local widgets/recipe_card.dart';
import '../../models/recipe_data.dart';
import '../../models/recipe.dart';
import '../../widgets/custom_drawer.dart';

class Recipes extends StatelessWidget {
  Recipes({Key? key}) : super(key: key);

  static const routeName = "/recipes";

  final List<Recipe> _recipeData = RecipeData().recipes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: const AppBarLeading(function: LeadingFunction.menu),
        title: const AppBarText(text: "RECIPES"),
        actions: [
          AppBarAddButton(onTap: () {
            Navigator.pushNamed(context, NewRecipe.routeName);
          })
        ],
      ),
      drawer: const Drawer(
        child: CustomDrawer(),
      ),
      body: SafeArea(
        child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          itemCount: _recipeData.length,
          itemBuilder: (BuildContext context, int index) {
            return RecipeCard(
              title: _recipeData[index].title,
              description: _recipeData[index].description,
              coffee: _recipeData[index].coffee,
              pushPressure: _recipeData[index].pushPressure,
              brewMethod: _recipeData[index].brewMethod,
              notes: _recipeData[index].notes,
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(
              color: Color(0x00000000),
              height: 20,
            );
          },
        ),
      ),
    );
  }
}
