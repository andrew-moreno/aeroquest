import 'package:aeroquest/constraints.dart';

import 'package:flutter/material.dart';

class ModalValueContainer extends StatefulWidget {
  /// Defines the structure of the container that holds the recipe variable
  /// text value
  const ModalValueContainer({
    Key? key,
    required this.child,
    required this.onTap,
    required this.displayBorder,
  }) : super(key: key);

  /// Child widget within the container
  final Widget child;

  /// Function to be executed when tapping on the container
  final Function() onTap;

  /// Whether or not to display a border around the container
  final bool displayBorder;

  @override
  State<ModalValueContainer> createState() => _ModalValueContainerState();
}

class _ModalValueContainerState extends State<ModalValueContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: widget.displayBorder ? null : const EdgeInsets.all(2),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: kLightSecondary,
          borderRadius: BorderRadius.circular(kCornerRadius),
          boxShadow: [kBoxShadow],
          border: widget.displayBorder
              ? Border.all(color: kAccent, width: 2)
              : null,
        ),
        child: widget.child,
      ),
    );
  }
}
