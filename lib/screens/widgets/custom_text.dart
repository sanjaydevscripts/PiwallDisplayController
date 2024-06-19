

import 'package:flutter/material.dart';
import 'package:pdc/core/constants.dart';

// ignore: must_be_immutable
class CustomText extends StatelessWidget {
  CustomText({
    super.key,
    required this.text,
    this.fontFamily = 'Manrope',
    this.fontSize = 14,
    this.fontColor = null,
    this.fontweight = FontWeight.normal,
    this.textAlign = TextAlign.start,
    this.underline = false,
    this.height = 1.5,
  });

  final String text;
  final String fontFamily;
  final double fontSize;
  Color? fontColor;
  final FontWeight fontweight;
  final TextAlign textAlign;
  final bool underline;
  final double height;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        color: fontColor,
        fontWeight: fontweight,
        decoration: underline ? TextDecoration.underline : TextDecoration.none,
        decorationColor: mainAppThemeColor,
        height: height,
      ),
      overflow: TextOverflow.visible,
      textAlign: textAlign,
    );
  }
}
