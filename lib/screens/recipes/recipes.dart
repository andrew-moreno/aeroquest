import 'package:aeroquest/widgets/exit_dialog.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:aeroquest/widgets/appbar/appbar_button.dart';
import 'package:aeroquest/widgets/appbar/appbar_leading.dart';
import 'package:aeroquest/widgets/appbar/appbar_text.dart';
import 'package:aeroquest/screens/recipes/local widgets/recipe_card.dart';
import 'package:aeroquest/providers/recipes_provider.dart';
import 'package:aeroquest/widgets/custom_drawer.dart';

class Recipes extends StatelessWidget {
  const Recipes({Key? key}) : super(key: key);

  static const routeName = "/recipes";

  @override
  Widget build(BuildContext context) {
    Future<bool> showExitPopup() async {
      return await showDialog(
            context: context,
            builder: (context) => ExitDialog(
              titleText: "Exit app?",
              leftAction: () => Navigator.of(context).pop(false),
              rightAction: () => Navigator.of(context).pop(true),
            ),
          ) ??
          false; //if showDialouge had returned null, then return false
    }

    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
        appBar: AppBar(
          leading: const AppBarLeading(function: LeadingFunction.menu),
          title: const AppBarText(text: "RECIPES"),
          actions: [
            AppBarButton(
              onTap: () {},
              icon: Icons.add,
            )
          ],
        ),
        drawer: const Drawer(
          child: CustomDrawer(),
        ),
        body: SafeArea(
          child: Consumer<RecipesProvider>(
            builder: (context, data, child) {
              return ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: data.recipes.length,
                itemBuilder: (context, index) {
                  return RecipeCard(
                    recipeData: data.recipes[index],
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    color: Color(0x00000000),
                    height: 20,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
