import 'package:aeroquest/constraints.dart';
import 'package:flutter/material.dart';

// only works for 2 positions
class AnimatedVerticalToggle extends StatefulWidget {
  AnimatedVerticalToggle({
    Key? key,
    required this.values,
    required this.onToggleCallback,
    required this.initialPosition,
  }) : super(key: key);

  final List<String> values;
  final ValueChanged onToggleCallback;
  Position initialPosition;

  @override
  _AnimatedVerticalToggleState createState() => _AnimatedVerticalToggleState();
}

class _AnimatedVerticalToggleState extends State<AnimatedVerticalToggle> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 60,
      child: GestureDetector(
        onTap: () {
          var index = 0;
          if (widget.initialPosition == Position.bottom) {
            widget.initialPosition = Position.top;
          } else {
            widget.initialPosition = Position.bottom;
            index = 1;
          }
          widget.onToggleCallback(index);
          setState(() {});
        },
        child: Stack(
          children: [
            Container(
              width: 90,
              height: 60,
              decoration: BoxDecoration(
                color: kLightSecondary,
                borderRadius: BorderRadius.circular(kCornerRadius),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  widget.values.length,
                  (index) => Container(
                    width: 90,
                    height: 30,
                    decoration: BoxDecoration(
                      color: kLightSecondary,
                      borderRadius: BorderRadius.circular(kCornerRadius),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        widget.values[index],
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
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
              alignment: widget.initialPosition == Position.top
                  ? Alignment.topCenter
                  : Alignment.bottomCenter,
              child: Container(
                width: 90,
                height: 30,
                decoration: ShapeDecoration(
                  color: kAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(kCornerRadius),
                  ),
                ),
                child: Text(
                  widget.initialPosition == Position.top
                      ? widget.values[0]
                      : widget.values[1],
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        color: kLightSecondary,
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

enum Position { top, bottom }
