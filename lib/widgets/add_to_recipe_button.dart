import 'package:aeroquest/constraints.dart';
import 'package:flutter/material.dart';

// used to
class AddToRecipeButton extends StatelessWidget {
  /// Defines the button used to add recipe settings or recipe steps to a recipe
  const AddToRecipeButton({
    Key? key,
    required this.onTap,
    required this.buttonText,
  }) : super(key: key);

  /// Function to be executed when pressing button
  final Function() onTap;

  /// Text to be displayed within the button
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(7),
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: kLightSecondary,
            borderRadius: BorderRadius.circular(kCornerRadius),
            boxShadow: [kBoxShadow],
          ),
          width: 150,
          child: Text(
            buttonText,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: kPrimary,
                fontFamily: "Poppins",
                fontSize: 20,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
