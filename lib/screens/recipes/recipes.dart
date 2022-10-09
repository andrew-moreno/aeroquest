import 'package:aeroquest/models/recipe_settings.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:aeroquest/widgets/appbar/appbar_button.dart';
import 'package:aeroquest/widgets/appbar/appbar_leading.dart';
import 'package:aeroquest/widgets/appbar/appbar_text.dart';
import 'package:aeroquest/screens/recipes/widgets/recipe_card.dart';
import 'package:aeroquest/providers/recipes_provider.dart';
import 'package:aeroquest/widgets/custom_drawer.dart';
import 'package:aeroquest/models/recipe.dart';
import 'package:aeroquest/widgets/exit_dialog.dart';

class Recipes extends StatefulWidget {
  const Recipes({Key? key}) : super(key: key);

  static const routeName = "/recipes";

  @override
  State<Recipes> createState() => _RecipesState();
}

class _RecipesState extends State<Recipes> {
  Recipe recipe1 = Recipe(
    id: 1,
    title: "Test Recipe1",
    description: "Testing testing 123 :)",
    pushPressure: PushPressure.light.name,
    brewMethod: BrewMethod.regular.name,
  );

  Recipe recipe2 = Recipe(
    id: 2,
    title: "Test Recipe2",
    description: "Testing testing 1234 :O",
    pushPressure: PushPressure.light.name,
    brewMethod: BrewMethod.regular.name,
  );

  RecipeSettings coffeeSettings1 = RecipeSettings(
      recipeEntryId: 1,
      beanId: 1,
      grindSetting: 18.0,
      coffeeAmount: 13.0,
      waterAmount: 150,
      waterTemp: 95,
      brewTime: 6,
      visibility: SettingVisibility.shown.name);

  RecipeSettings coffeeSettings2 = RecipeSettings(
      recipeEntryId: 2,
      beanId: 3,
      grindSetting: 16.0,
      coffeeAmount: 18.0,
      waterAmount: 260,
      waterTemp: 95,
      brewTime: 6,
      visibility: SettingVisibility.shown.name);

  @override
  Widget build(BuildContext context) {
    // TODO: delete after testing
    //RecipesDatabase.instance.create(recipe2);
    //RecipeSettingsDatabase.instance.create(coffeeSettings2);
    //RecipesDatabase.instance.delete(550);
    //CoffeeSettingsDatabase.instance.delete(550);
    //RecipesDatabase.instance.deleteDB();
    //RecipeSettingsDatabase.instance.deleteDB();
    //CoffeeBeansDatabase.instance.deleteDB();
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
          child: FutureBuilder(
              future: Provider.of<RecipesProvider>(context, listen: false)
                  .cacheRecipesAndSettings(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Consumer<RecipesProvider>(
                      builder: (_, recipesProvider, ___) {
                    return ListView.separated(
                      padding: const EdgeInsets.all(20),
                      itemCount: recipesProvider.recipes.length,
                      itemBuilder: (context, index) {
                        return RecipeCard(
                          recipeData: recipesProvider.recipes[index],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Divider(
                          color: Color(0x00000000),
                          height: 20,
                        );
                      },
                    );
                  });
                } else {
                  return const CircularProgressIndicator();
                }
              }),
        ),
      ),
    );
  }
}
