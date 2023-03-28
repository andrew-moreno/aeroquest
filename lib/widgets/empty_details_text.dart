import 'package:aeroquest/constraints.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EmptyDetailsText extends StatelessWidget {
  /// Used to notify the user that no variables, steps, or notes are present in
  /// the recipe details page
  const EmptyDetailsText({
    Key? key,
    required this.dataType,
  }) : super(key: key);

  /// Data type that is missing
  final RecipeDetailsText dataType;

  String _descriptionText(dataType) {
    if (dataType == RecipeDetailsText.variable) {
      return "set of ${describeEnum(dataType)}s";
    } else {
      return describeEnum(dataType);
    }
  }

  @override
  Widget build(BuildContext context) {
    String capitalizedData = describeEnum(dataType)[0].toUpperCase() +
        describeEnum(dataType).substring(1).toLowerCase();
    return Column(
      children: [
        Text(
          "No ${capitalizedData}s Added",
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: kLightSecondary,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w600,
            fontSize: 25,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Edit the recipe to add a ${_descriptionText(dataType)}",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            color: kLightSecondary,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }
}

enum RecipeDetailsText {
  variable,
  step,
  note,
}
