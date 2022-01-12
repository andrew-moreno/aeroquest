import 'package:aeroquest/widgets/appbar/appbar_leading.dart';
import 'package:aeroquest/widgets/appbar/appbar_text.dart';
import 'package:flutter/material.dart';

import '../../constraints.dart';

class NewRecipe extends StatelessWidget {
  const NewRecipe({Key? key}) : super(key: key);

  static const routeName = "/newRecipe";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: const AppBarLeading(function: LeadingFunction.back),
        title: const AppBarText(text: "NEW RECIPE"),
      ),
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
