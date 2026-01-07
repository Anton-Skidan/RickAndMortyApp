import 'package:flutter/material.dart';

class CharacterInfoView extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final int maxLines;

  const CharacterInfoView({
    super.key,
    required this.text,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w400,
    this.textAlign = TextAlign.right,
    this.maxLines = 2,
  });

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      color: Colors.white,
      fontSize: fontSize,
      fontWeight: fontWeight,
      shadows: const [
        Shadow(blurRadius: 4, color: Colors.black, offset: Offset(0, 1)),
      ],
    );

    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: style,
    );
  }
}
