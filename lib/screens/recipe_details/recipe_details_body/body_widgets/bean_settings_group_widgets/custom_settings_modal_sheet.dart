import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:aeroquest/providers/recipes_provider.dart';
import 'package:aeroquest/screens/recipe_details/recipe_details_body/body_widgets/bean_settings_group_widgets/settings_value_slider.dart';
import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/models/recipe_entry.dart';
import 'package:aeroquest/providers/beans_provider.dart';
import 'package:aeroquest/widgets/animated_toggle.dart';
import 'package:aeroquest/widgets/modal_button.dart';

class CustomSettingsModalSheet extends StatefulWidget {
  const CustomSettingsModalSheet({
    Key? key,
    required this.submitAction,
    this.deleteAction,
    this.coffeeSettingsData,
  }) : super(key: key);

  final Function() submitAction;
  final Function()? deleteAction;
  final CoffeeSettings? coffeeSettingsData;

  @override
  State<CustomSettingsModalSheet> createState() =>
      _CustomSettingsModalSheetState();
}

class _CustomSettingsModalSheetState extends State<CustomSettingsModalSheet> {
  final List<String> _animatedToggleValues = const ["Show", "Hide"];

  @override
  void initState() {
    super.initState();
    Provider.of<RecipesProvider>(context, listen: false).tempSettingVisibility =
        widget.coffeeSettingsData?.visibility ?? SettingVisibility.shown;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20),
      child: LayoutBuilder(builder: (context, constraints) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedToggle(
              values: _animatedToggleValues,
              onToggleCallback: (index) {
                print(index);
                index == 0
                    ? Provider.of<RecipesProvider>(context, listen: false)
                        .tempSettingVisibility = SettingVisibility.shown
                    : Provider.of<RecipesProvider>(context, listen: false)
                        .tempSettingVisibility = SettingVisibility.hidden;
                print(Provider.of<RecipesProvider>(context, listen: false)
                    .tempSettingVisibility);
              },
              initialPosition:
                  (Provider.of<RecipesProvider>(context, listen: false)
                              .tempSettingVisibility ==
                          SettingVisibility.shown)
                      ? Position.left
                      : Position.right,
            ),
            const Divider(height: 20, color: Color(0x00000000)),
            DropdownButtonHideUnderline(
              child: DropdownButtonFormField2(
                items: List.generate(
                  Provider.of<BeansProvider>(context).beans.length,
                  (index) => DropdownMenuItem(
                    child: Text(
                      Provider.of<BeansProvider>(context).beans[index].beanName,
                      style: const TextStyle(color: kPrimary, fontSize: 16),
                    ),
                    value: Provider.of<BeansProvider>(context)
                        .beans[index]
                        .beanName,
                  ),
                ),
                value: widget.coffeeSettingsData?.beanName,
                onChanged: (value) {
                  Provider.of<RecipesProvider>(context, listen: false)
                      .tempBeanName = value.toString();
                  setState(() {});
                },
                decoration: const InputDecoration(
                  hintText: "Select a bean",
                ),
                dropdownDecoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.all(Radius.circular(kCornerRadius)),
                  color: kLightSecondary,
                ),
                buttonWidth: double.infinity,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: kPrimary,
                ),
              ),
            ),
            const Divider(height: 20, color: Color(0x00000000)),
            SettingsValueSlider(
              maxWidth: constraints.maxWidth,
              coffeeSettingsData: widget.coffeeSettingsData,
            ),
            const Divider(height: 20, color: Color(0x00000000)),
            Row(
              mainAxisAlignment: (widget.deleteAction != null)
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.center,
              children: [
                ModalButton(
                  onTap: widget.submitAction,
                  buttonType: ButtonType.positive,
                  text: "Save",
                  width: constraints.maxWidth / 2 - 10,
                ),
                (widget.deleteAction != null)
                    ? ModalButton(
                        onTap: widget.deleteAction!,
                        buttonType: ButtonType.negative,
                        text: "Delete",
                        width: constraints.maxWidth / 2 - 10,
                      )
                    : Container(),
              ],
            ),
          ],
        );
      }),
    );
  }
}
