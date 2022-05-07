import 'package:aeroquest/models/recipe_entry.dart';
import 'package:aeroquest/screens/recipe_details/widgets/recipe_details_body.dart';
import 'package:aeroquest/screens/recipe_details/widgets/recipe_details_header.dart';
import 'package:aeroquest/widgets/appbar/appbar_addButton.dart';
import 'package:aeroquest/widgets/appbar/appbar_leading.dart';
import 'package:flutter/material.dart';
import 'package:aeroquest/constraints.dart';

class RecipeDetails extends StatefulWidget {
  const RecipeDetails({
    Key? key,
    required recipeData,
  })  : _recipeData = recipeData,
        super(key: key);

  final RecipeEntry _recipeData;

  @override
  State<RecipeDetails> createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimary,
        elevation: 0,
        centerTitle: true,
        leading: const AppBarLeading(function: LeadingFunction.back),
        actions: [AppBarAddButton(onTap: () {}, icon: Icons.edit)],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Divider(
                height: 10,
                color: Color(0x00000000),
              ),
              RecipeDetailsHeader(
                title: widget._recipeData.title,
                description: widget._recipeData.description,
              ),
              const Divider(
                height: 20,
                color: Color(0x00000000),
              ),
              RecipeDetailsBody(
                recipeData: widget._recipeData,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
