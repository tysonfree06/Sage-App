import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';

class IdeaTag extends StatelessWidget {
  const IdeaTag({
    required this.label,
    super.key,
    this.fontSize = 11,
    this.horizontalPadding = 10,
    this.verticalPadding = 2,
  });

  final double fontSize;
  final double horizontalPadding;
  final double verticalPadding;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding.w,
        vertical: verticalPadding.h,
      ),
      decoration: BoxDecoration(
        color: Colors.teal.shade600,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: context.colors.yellow,
          fontWeight: FontWeight.w500,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
