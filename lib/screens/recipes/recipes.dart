import 'package:flutter/material.dart';

import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/widgets/appbar/appbar_addButton.dart';
import 'package:aeroquest/widgets/appbar/appbar_leading.dart';
import 'package:aeroquest/widgets/appbar/appbar_text.dart';
import 'package:aeroquest/widgets/modal_button.dart';
import 'package:aeroquest/screens/recipes/local widgets/recipe_card.dart';
import 'package:aeroquest/models/recipe_data.dart';
import 'package:aeroquest/models/recipe_entry.dart';
import 'package:aeroquest/widgets/custom_drawer.dart';

class Recipes extends StatelessWidget {
  Recipes({Key? key}) : super(key: key);

  static const routeName = "/recipes";

  final List<RecipeEntry> _recipeData = RecipeData().recipes;

  @override
  Widget build(BuildContext context) {
    Future<bool> showExitPopup() async {
      return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text(
                'Exit App?',
                style: TextStyle(
                  color: kPrimary,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
              actionsAlignment: MainAxisAlignment.spaceAround,
              actions: [
                ModalButton(
                    onTap: () => Navigator.of(context).pop(false),
                    buttonType: ButtonType.positive,
                    text: "No",
                    width: 100.0),
                ModalButton(
                    onTap: () => Navigator.of(context).pop(true),
                    buttonType: ButtonType.negative,
                    text: "Yes",
                    width: 100.0)
              ],
              backgroundColor: kDarkSecondary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kCornerRadius)),
            ),
          ) ??
          false; //if showDialouge had returned null, then return false
    }

    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimary,
          elevation: 0,
          centerTitle: true,
          leading: const AppBarLeading(function: LeadingFunction.menu),
          title: const AppBarText(text: "RECIPES"),
          actions: [
            AppBarAddButton(
              onTap: () {},
              icon: Icons.add,
            )
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
                recipeData: _recipeData[index],
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
      ),
    );
  }
}
