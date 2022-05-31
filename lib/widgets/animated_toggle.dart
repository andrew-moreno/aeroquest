import 'package:aeroquest/constraints.dart';
import 'package:flutter/material.dart';

// only works for 2 positions
class AnimatedToggle extends StatefulWidget {
  AnimatedToggle({
    Key? key,
    required this.values,
    required this.onToggleCallback,
    required this.initialPosition,
  }) : super(key: key);

  final List<String> values;
  final ValueChanged onToggleCallback;
  Position initialPosition;

  @override
  _AnimatedToggleState createState() => _AnimatedToggleState();
}

class _AnimatedToggleState extends State<AnimatedToggle> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 40,
      child: GestureDetector(
        onTap: () {
          var index = 0;
          if (widget.initialPosition == Position.right) {
            widget.initialPosition = Position.left;
          } else {
            widget.initialPosition = Position.right;
            index = 1;
          }
          widget.onToggleCallback(index);
          setState(() {});
        },
        child: Stack(
          children: [
            Container(
              width: 150,
              height: 40,
              decoration: BoxDecoration(
                color: kLightSecondary,
                borderRadius: BorderRadius.circular(kCornerRadius),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  widget.values.length,
                  (index) => Container(
                    width: 75,
                    height: 40,
                    decoration: BoxDecoration(
                      color: kLightSecondary,
                      borderRadius: BorderRadius.circular(kCornerRadius),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        widget.values[index],
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: kDarkSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              curve: Curves.decelerate,
              alignment: widget.initialPosition == Position.left
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: Container(
                width: 75,
                height: 40,
                decoration: ShapeDecoration(
                  color: kAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(kCornerRadius),
                  ),
                ),
                child: Text(
                  widget.initialPosition == Position.left
                      ? widget.values[0]
                      : widget.values[1],
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    color: kLightSecondary,
                    fontWeight: FontWeight.w600,
                  ),
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

enum Position { left, right }
