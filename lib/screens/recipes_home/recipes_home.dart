import 'package:flutter/material.dart';

import '../recipes_home/local widgets/appbar.dart';
import 'local widgets/recipe_card.dart';
import '../../models/recipe_data.dart';
import '../../models/recipe.dart';

class RecipesHome extends StatelessWidget {
  RecipesHome({Key? key}) : super(key: key);

  final List<Recipe> _recipeData = RecipeData().recipes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const Drawer(
        child: Text("This is a drawer :)"),
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
