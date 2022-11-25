import 'package:aeroquest/screens/recipe_details/recipe_details_body/body_widgets/bean_settings_group_widgets/coffee_bean_dropdown.dart';
import 'package:aeroquest/widgets/animated_toggle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:aeroquest/providers/recipes_provider.dart';
import 'package:aeroquest/screens/recipe_details/recipe_details_body/body_widgets/bean_settings_group_widgets/settings_value_slider_group.dart';
import 'package:aeroquest/widgets/custom_button.dart';
import 'package:aeroquest/models/recipe_settings.dart';

class SettingsModalSheet extends StatefulWidget {
  /// Defines the modal sheet used for editing recipe settings
  const SettingsModalSheet({
    Key? key,
    required this.submitAction,
    this.deleteAction,
    this.recipeSettingsData,
  }) : super(key: key);

  /// Function to execute when submitting the modal sheet
  final Function() submitAction;

  /// Function to execute when pressing the delete button on the modal sheet
  final Function()? deleteAction;

  /// Recipe settings data being passed
  final RecipeSettings? recipeSettingsData;

  @override
  State<SettingsModalSheet> createState() => _SettingsModalSheetState();
}

class _SettingsModalSheetState extends State<SettingsModalSheet> {
  /// Options used for the animated toggle responsible for showing and hiding
  /// recipe settings
  final List<String> _animatedToggleValues = const ["Show", "Hide"];

  @override
  void initState() {
    super.initState();
    Provider.of<RecipesProvider>(context, listen: false).tempSettingVisibility =
        (widget.recipeSettingsData?.visibility == null)
            ? SettingVisibility.shown
            : RecipeSettings.stringToSettingVisibility(
                widget.recipeSettingsData!.visibility);
    Provider.of<RecipesProvider>(context, listen: false).tempBeanId =
        widget.recipeSettingsData?.beanId;
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
              /// Show/Hide animated toggle
              AnimatedToggle(
                values: _animatedToggleValues,
                onToggleCallback: (index) {
                  index == 0
                      ? Provider.of<RecipesProvider>(context, listen: false)
                          .tempSettingVisibility = SettingVisibility.shown
                      : Provider.of<RecipesProvider>(context, listen: false)
                          .tempSettingVisibility = SettingVisibility.hidden;
                },
                initialPosition:
                    (Provider.of<RecipesProvider>(context, listen: false)
                                .tempSettingVisibility ==
                            SettingVisibility.shown)
                        ? Position.first
                        : Position.last,
                toggleType: ToggleType.horizontal,
              ),
              const SizedBox(height: 20),
              CoffeeBeanDropdown(
                recipeSettingsData: widget.recipeSettingsData,
              ),
              // Spacing handled in CoffeeBeanDropdown
              SettingsValueSliderGroup(
                maxWidth: constraints.maxWidth,
                recipeSettingsData: widget.recipeSettingsData,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: (widget.deleteAction != null)
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.center,
                children: [
                  CustomButton(
                    onTap: widget.submitAction,
                    buttonType: ButtonType.vibrant,
                    text: "Save",
                    width: constraints.maxWidth / 2 - 10,
                  ),
                  (widget.deleteAction != null)
                      ? CustomButton(
                          onTap: widget.deleteAction!,
                          buttonType: ButtonType.normal,
                          text: "Delete",
                          width: constraints.maxWidth / 2 - 10,
                        )
                      : Container(),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
