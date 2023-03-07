import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class AppSettingsModalSheet extends StatelessWidget {
  /// Defines the app settings modal sheet template
  const AppSettingsModalSheet({
    Key? key,
    required this.text,
    required this.editor,
    required this.onSave,
  }) : super(key: key);

  /// Text to be displayed above the editor widget
  final String text;

  /// Widget used for selecting the different setting options
  final Widget editor;

  /// Function to be executed when modal is submitted
  final Function() onSave;

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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                width: double.infinity,
                child: Text(
                  text,
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 15,
                    color: kSubtitle,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              editor,
              const SizedBox(height: 20),
              CustomButton(
                onTap: () => onSave(),
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
