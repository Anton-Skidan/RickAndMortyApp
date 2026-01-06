import 'package:flutter/material.dart';

class CharacterInfoView extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;

  const CharacterInfoView({
    super.key,
    required this.text,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w400,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.right,
      style: TextStyle(
        color: Colors.white,
        fontSize: fontSize,
        fontWeight: fontWeight,
        shadows: const [
          Shadow(
            blurRadius: 4,
            color: Colors.black,
            offset: Offset(0, 1),
          ),
        ],
      ),
    );
  }
}