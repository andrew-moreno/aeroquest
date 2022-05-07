import 'package:flutter/material.dart';
import 'package:aeroquest/constraints.dart';

class RecipeDetailsHeader extends StatelessWidget {
  const RecipeDetailsHeader({Key? key, required title, required description})
      : _title = title,
        _description = description,
        super(key: key);

  final String _title;
  final String _description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              //boxShadow: [kBoxShadow],
              color: kPrimary,
              borderRadius: BorderRadius.circular(kCornerRadius),
            ),
            width: double.infinity,
            padding: const EdgeInsets.all(4),
            child: Text(
              _title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: kLightSecondary,
                fontFamily: "Spectral",
                fontSize: 35,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
          ),
          const Divider(
            height: 10,
            color: Color(0x00000000),
          ),
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              //boxShadow: [kBoxShadow],
              color: kPrimary,
              borderRadius: BorderRadius.circular(6),
            ),
            width: double.infinity,
            child: Text(
              _description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: kLightSecondary,
                  fontFamily: "Poppins",
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }
}
