import 'package:flutter/material.dart';

import '../../constraints.dart';
import '../recipes_home/local widgets/appbar.dart';
import 'local widgets/recipe_card.dart';
import '../../models/recipe_data.dart';
import '../../models/recipe.dart';

class RecipesHome extends StatelessWidget {
  RecipesHome({Key? key}) : super(key: key);

  final List<Recipe> recipeData = RecipeData().recipes;

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
          itemCount: recipeData.length,
          itemBuilder: (BuildContext context, int index) {
            return RecipeCard(
              title: recipeData[index].title,
              description: recipeData[index].description,
              coffee: recipeData[index].coffee,
              pushPressure: recipeData[index].pushPressure,
              brewMethod: recipeData[index].brewMethod,
              notes: recipeData[index].notes,
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
