import 'package:aeroquest/constraints.dart';
import 'package:flutter/material.dart';

// TODO: make build more optimized by extracting moving part
class AnimatedToggle extends StatefulWidget {
  /// Defines the toggle widget for selecting between values stacked
  /// horizontally
  ///
  /// Built for use when selecting the visibility of recipe settings
  ///
  /// Only functions as a two position toggle
  const AnimatedToggle({
    Key? key,
    required this.values,
    required this.onToggleCallback,
    required this.initialPosition,
    required this.toggleType,
  }) : super(key: key);

  /// Possible selections to be made with the toggle
  final List<String> values;

  /// Callback for executing commands based on the current index of the toggle
  final ValueChanged onToggleCallback;

  /// The position that the toggle should start at
  final Position initialPosition;

  /// Whether the toggle will be used horizontally or vertically
  final ToggleType toggleType;

  @override
  _AnimatedToggleState createState() => _AnimatedToggleState();
}

class _AnimatedToggleState extends State<AnimatedToggle> {
  /// Current position that the toggle is at
  late Position _currentPosition;

  @override
  void initState() {
    _currentPosition = widget.initialPosition;
    super.initState();
  }

  // Constants for defining the toggle size
  static const double _horizontalHeight = 40;
  static const double _horizontalWidth = 75;
  static const double _verticalHeight = 30;
  static const double _verticalWidth = 90;

  /// Selects the toggle size depending on whether the toggle is displayed
  /// horizontally or vertically
  ///
  /// If [isDoubled] is true, the appropriate value will be doubled
  ToggleSizeConstrains _sizeConstraintsType(
    ToggleType toggleType,
    bool isDoubled,
  ) {
    switch (toggleType) {
      case ToggleType.horizontal:
        {
          if (isDoubled) {
            return ToggleSizeConstrains(
              height: _horizontalHeight,
              width: _horizontalWidth * 2,
            );
          }
          return ToggleSizeConstrains(
            height: _horizontalHeight,
            width: _horizontalWidth,
          );
        }

      case ToggleType.vertical:
        {
          if (isDoubled) {
            return ToggleSizeConstrains(
              height: _verticalHeight * 2,
              width: _verticalWidth,
            );
          }
          return ToggleSizeConstrains(
            height: _verticalHeight,
            width: _verticalWidth,
          );
        }
    }
  }

  /// Selects the text style for the toggle depending on whether the toggle
  /// is displayed horizontally or vertically
  ///
  /// If [isDark] is true, text colour will be [kDarkSecondary]. Otherwise,
  /// it will be [kLightSecondary]
  TextStyle _textStyle(
    ToggleType toggleType,
    bool isDark,
  ) {
    switch (toggleType) {
      case ToggleType.horizontal:
        {
          if (isDark) {
            return const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              color: kDarkSecondary,
              fontWeight: FontWeight.w600,
            );
          }
          return const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            color: kLightSecondary,
            fontWeight: FontWeight.w600,
          );
        }

      case ToggleType.vertical:
        {
          if (isDark) {
            return const TextStyle(
              fontFamily: "Poppins",
              fontSize: 14,
              color: kDarkSecondary,
              fontWeight: FontWeight.w600,
            );
          }
          return const TextStyle(
            fontFamily: "Poppins",
            fontSize: 14,
            color: kLightSecondary,
            fontWeight: FontWeight.w600,
          );
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _sizeConstraintsType(widget.toggleType, true).width,
      height: _sizeConstraintsType(widget.toggleType, true).height,
      child: GestureDetector(
        onTap: () {
          var index = 0;
          if (_currentPosition == Position.second) {
            _currentPosition = Position.first;
          } else {
            _currentPosition = Position.second;
            index = 1;
          }
          widget.onToggleCallback(index);
          setState(() {});
        },
        child: Stack(
          children: [
            Container(
              width: _sizeConstraintsType(widget.toggleType, true).width,
              height: _sizeConstraintsType(widget.toggleType, true).height,
              decoration: BoxDecoration(
                color: kLightSecondary,
                borderRadius: BorderRadius.circular(kCornerRadius),
              ),
              child: Flex(
                direction: widget.toggleType == ToggleType.horizontal
                    ? Axis.horizontal
                    : Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  widget.values.length,
                  (index) => Container(
                    width: _sizeConstraintsType(widget.toggleType, false).width,
                    height:
                        _sizeConstraintsType(widget.toggleType, false).height,
                    decoration: BoxDecoration(
                      color: kLightSecondary,
                      borderRadius: BorderRadius.circular(kCornerRadius),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        widget.values[index],
                        style: _textStyle(widget.toggleType, true),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              curve: Curves.decelerate,
              alignment: (widget.toggleType == ToggleType.horizontal)
                  ? (_currentPosition == Position.first
                      ? Alignment.centerLeft
                      : Alignment.centerRight)
                  : (_currentPosition == Position.first
                      ? Alignment.topCenter
                      : Alignment.bottomCenter),
              child: Container(
                width: _sizeConstraintsType(widget.toggleType, false).width,
                height: _sizeConstraintsType(widget.toggleType, false).height,
                decoration: ShapeDecoration(
                  color: kAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(kCornerRadius),
                  ),
                ),
                child: Text(
                  _currentPosition == Position.first
                      ? widget.values[0]
                      : widget.values[1],
                  style: _textStyle(widget.toggleType, false),
                ),
                alignment: Alignment.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Describes the choice of positions that a toggle can be at
///
/// For vertical toggles, [first] position is at the top. For horizontal
/// toggles, [first] position is left
enum Position {
  first,
  second,
}

/// Describes the direction the toggle will operate in
enum ToggleType {
  horizontal,
  vertical,
}

/// Defines object for a toggles size constraints
class ToggleSizeConstrains {
  ToggleSizeConstrains({
    required this.height,
    required this.width,
  });

  final double height;
  final double width;
}
