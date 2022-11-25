import 'package:flutter/material.dart';

import 'package:aeroquest/widgets/appbar/appbar_leading.dart';
import 'package:aeroquest/widgets/appbar/appbar_text.dart';
import 'package:aeroquest/widgets/custom_drawer.dart';
import 'package:aeroquest/constraints.dart';

class AboutAeroquest extends StatelessWidget {
  /// Defines the screen used for sharing information about myself and the
  /// app :)
  const AboutAeroquest({Key? key}) : super(key: key);

  static const routeName = "/aboutAeroquest";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimary,
        elevation: 0,
        centerTitle: true,
        leading: const AppBarLeading(leadingFunction: LeadingFunction.menu),
        title: const AppBarText(text: "About AEROQUEST"),
      ),
      drawer: const CustomDrawer(),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            "Hope u like my app and make great coffee :)",
            style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 17,
                color: kLightSecondary,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
