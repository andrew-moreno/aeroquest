import 'package:aeroquest/screens/recipe_details/recipe_details.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:aeroquest/widgets/appbar/appbar_button.dart';
import 'package:aeroquest/widgets/appbar/appbar_leading.dart';
import 'package:aeroquest/widgets/appbar/appbar_text.dart';
import 'package:aeroquest/screens/recipes/widgets/recipe_card.dart';
import 'package:aeroquest/providers/recipes_provider.dart';
import 'package:aeroquest/widgets/custom_drawer.dart';
import 'package:aeroquest/widgets/custom_dialog.dart';

class Recipes extends StatefulWidget {
  /// Defines the screen for displaying all recipes
  const Recipes({Key? key}) : super(key: key);

  static const routeName = "/recipes";

  @override
  State<Recipes> createState() => _RecipesState();
}

class _RecipesState extends State<Recipes> {
  /// Confirmation for exiting the app when the user clicks the OS back button
  Future<bool> showExitPopup() async {
    return await showDialog(
          context: context,
          builder: (context) => CustomDialog(
            titleText: "Exit app?",
            leftAction: () => Navigator.of(context).pop(false),
            rightAction: () => Navigator.of(context).pop(true),
          ),
        ) ??
        false; //if showDialog had returned null, then return false
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
        appBar: AppBar(
          leading: const AppBarLeading(leadingFunction: LeadingFunction.menu),
          title: const AppBarText(text: "RECIPES"),
          actions: [
            AppBarButton(
              onTap: () async {
                Provider.of<RecipesProvider>(context, listen: false)
                    .tempAddRecipe()
                    .then(
                      (tempRecipe) => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RecipeDetails(
                            recipeData: tempRecipe,
                            isAdding: true,
                          ),
                        ),
                      ),
                    );
              },
              icon: Icons.add,
            )
          ],
        ),
        drawer: const Drawer(
          child: CustomDrawer(),
        ),
        body: SafeArea(
          child: FutureBuilder(
            future: Provider.of<RecipesProvider>(context, listen: false)
                .cacheRecipeData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Consumer<RecipesProvider>(
                  builder: (context, recipesProvider, ___) {
                    return ListView.separated(
                      padding: const EdgeInsets.all(20),
                      itemCount: recipesProvider.recipes.length,
                      itemBuilder: (context, index) {
                        return RecipeCard(
                          recipeData: recipesProvider.recipes[index],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 20);
                      },
                    );
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}
