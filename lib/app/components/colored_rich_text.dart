import 'package:flutter/material.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';

class ColoredRichText extends StatelessWidget {
  const ColoredRichText({
    required this.first,
    required this.second,
    super.key,
    this.firstColor,
    this.secondColor,
    this.fontSize = 24,
    this.fontWeight = FontWeight.w700,
  });
  final String first;
  final String second;
  final Color? firstColor;
  final Color? secondColor;
  final double fontSize;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: first,
            style: context.typography.title.copyWith(
              color: firstColor ?? context.colors.textLightGreen,
              fontSize: fontSize,
              fontWeight: fontWeight,
              letterSpacing: -.2,
            ),
          ),
          TextSpan(
            text: second,
            style: context.typography.title.copyWith(
              color: secondColor ?? context.colors.textDarkGreen,
              fontSize: fontSize,
              fontWeight: fontWeight,
              letterSpacing: -.2,
            ),
          ),
        ],
      ),
    );
  }
}
