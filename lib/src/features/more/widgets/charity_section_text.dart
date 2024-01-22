import 'package:flutter/material.dart';

class CharitySectionText extends StatelessWidget {
  const CharitySectionText({
    super.key,
    required this.text,
    required this.fontSize,
  });

  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: fontSize),
      textAlign: TextAlign.center,
    );
  }
}
