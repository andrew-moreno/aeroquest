import 'package:aeroquest/widgets/appbar/appbar_addButton.dart';
import 'package:aeroquest/widgets/appbar/appbar_leading.dart';
import 'package:aeroquest/widgets/appbar/appbar_text.dart';
import 'package:aeroquest/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

import '../../constraints.dart';

class CoffeeBeans extends StatelessWidget {
  const CoffeeBeans({Key? key}) : super(key: key);

  static const routeName = "/manageBeans";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: const AppBarLeading(function: LeadingFunction.menu),
        title: const AppBarText(text: "BEANS"),
        actions: [AppBarAddButton(onTap: () {})],
      ),
      drawer: const CustomDrawer(),
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
