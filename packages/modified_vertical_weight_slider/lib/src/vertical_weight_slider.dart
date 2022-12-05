import 'package:flutter/material.dart';
import 'package:vertical_weight_slider/src/widgets/weight_pointer.dart';
import '../vertical_weight_slider.dart';

class VerticalWeightSlider extends StatefulWidget {
  const VerticalWeightSlider({
    Key? key,
    required this.controller,
    this.maxWeight = 300,
    this.height = 250.0,
    this.decoration = const PointerDecoration(),
    this.indicator,
    this.disableScrolling = false,
    required this.maxWidth,
    required this.onChanged,
  })  : assert(maxWeight >= 0),
        super(key: key);

  /// A controller for scroll views whose items have the same size.
  final WeightSliderController controller;

  /// Maximum weight that the slider can be scrolled
  final int maxWeight;

  /// If non-null, requires the child to have exactly this height.
  final double height;

  /// Pointer configuration
  final PointerDecoration decoration;

  /// Describes the configuration for a vertical weight slider.
  final Widget? indicator;

  /// Bounding constrains of parent widget
  final double maxWidth;

  /// On optional listener that's called when the centered item changes.
  final ValueChanged<double> onChanged;

  /// used for enabling and disabling scroll physics
  final bool disableScrolling;

  @override
  State<VerticalWeightSlider> createState() => _VerticalWeightSliderState();
}

class _VerticalWeightSliderState extends State<VerticalWeightSlider> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      child: RotatedBox(
        quarterTurns: 3,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ListWheelScrollView(
              itemExtent: widget.controller.itemExtent,
              diameterRatio: 20,
              controller: widget.controller,
              physics: widget.disableScrolling
                  ? NeverScrollableScrollPhysics()
                  : FixedExtentScrollPhysics(),
              perspective: 0.001,
              children: List<Widget>.generate(
                [
                  for (int i = widget.controller.minWeight *
                          widget.controller.getIntervalToInt();
                      i <=
                          widget.maxWeight *
                              widget.controller.getIntervalToInt();
                      i++)
                    i
                ].length,
                (index) => Center(
                  child: (index ==
                              widget.maxWeight *
                                  widget.controller.getIntervalToInt() ||
                          index == 0)
                      ? WeightPointer(
                          color: widget.decoration.largeColor,
                          width: widget.decoration.width + 30,
                          height: widget.decoration.height,
                        )
                      : WeightPointer(
                          color: widget.decoration.mediumColor,
                          width: widget.decoration.width,
                          height: widget.decoration.height,
                        ),
                ),
              ),
              onSelectedItemChanged: (index) {
                widget.onChanged(
                  (index / widget.controller.getIntervalToInt()) +
                      widget.controller.minWeight,
                );
              },
            ),
            widget.indicator ?? const SizedBox(),
          ],
        ),
      ),
    );
  }
}
