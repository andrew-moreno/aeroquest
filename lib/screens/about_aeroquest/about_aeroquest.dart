import 'package:aeroquest/widgets/appbar/appbar_leading.dart';
import 'package:aeroquest/widgets/appbar/appbar_text.dart';
import 'package:aeroquest/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

import '../../constraints.dart';

class AboutAeroquest extends StatelessWidget {
  const AboutAeroquest({Key? key}) : super(key: key);

  static const routeName = "/aboutAeroquest";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: const AppBarLeading(function: LeadingFunction.menu),
        title: const AppBarText(text: "About AEROQUEST"),
      ),
      drawer: const CustomDrawer(),
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
