import 'package:aeroquest/providers/app_settings_provider.dart';
import 'package:aeroquest/providers/recipes_provider.dart';
import 'package:aeroquest/providers/settings_slider_provider.dart';
import 'package:aeroquest/widgets/custom_button.dart';
import 'package:aeroquest/widgets/custom_modal_sheet/modal_value_container.dart';
import 'package:aeroquest/widgets/recipe_parameters_value.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class GrindIntervalModalSheet extends StatefulWidget {
  /// Defines the modal sheet used for editing the grind setting interval
  const GrindIntervalModalSheet({
    Key? key,
    required this.initialGrindInterval,
  }) : super(key: key);

  /// Initial value of the grind interval to display in the modal sheet
  final double initialGrindInterval;

  @override
  State<GrindIntervalModalSheet> createState() =>
      _GrindIntervalModalSheetState();
}

class _GrindIntervalModalSheetState extends State<GrindIntervalModalSheet> {
  late final RecipesProvider _recipesProvider;
  late final SettingsSliderProvider _settingsSliderProvider;

  /// Temporary grind interval value that is used to select a value in the
  /// modal sheet without saving to the Shared Preferences db
  late double _tempGrindInterval;

  /// Possible grind interval values that can be set
  static const List<double> intervalValues = [0.1, 0.2, 0.25, 0.33, 0.5, 1];

  @override
  void initState() {
    super.initState();
    _tempGrindInterval = widget.initialGrindInterval;

    /// Used to initialize providers for use in [dispose] method
    _recipesProvider = Provider.of<RecipesProvider>(context, listen: false);
    _settingsSliderProvider =
        Provider.of<SettingsSliderProvider>(context, listen: false);
  }

  @override
  void dispose() {
    _recipesProvider.clearTempRecipeStepParameters();
    _settingsSliderProvider.clearTempRecipeStepParameters();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (int index = 0; index < intervalValues.length; index++)
                    ModalValueContainer(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 10,
                        ),
                        child: RecipeParameterValue(
                          parameterValue: intervalValues[index],
                          parameterType: ParameterType.none,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _tempGrindInterval = intervalValues[index];
                        });
                      },
                      displayBorder:
                          _tempGrindInterval == intervalValues[index],
                    )
                ],
              ),
              const SizedBox(height: 20),
              CustomButton(
                onTap: () {
                  Provider.of<AppSettingsProvider>(context, listen: false)
                      .updateGrindInterval(_tempGrindInterval);
                  Navigator.of(context).pop();
                },
                buttonType: ButtonType.vibrant,
                text: "Save",
                width: constraints.maxWidth / 2 - 10,
              ),
            ],
          );
        },
      ),
    );
  }
}
