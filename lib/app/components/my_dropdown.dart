import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/styles/app_dimensions.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/app/utils/extensions/general_extensions.dart';

class MyDropdown<T> extends StatelessWidget {
  const MyDropdown({
    required this.items,
    required this.onChanged,
    super.key,
    this.value,
    this.hint,
    this.label,
    this.validator,
    this.decoration,
    this.autovalidateMode,
    this.displayString,
  });

  final List<T> items;
  final T? value;
  final String? hint;
  final String? label;
  final void Function(T?) onChanged;
  final String? Function(T?)? validator;
  final AutovalidateMode? autovalidateMode;
  final InputDecoration? decoration;

  /// Optional function to control how to display the item string
  final String Function(T)? displayString;

  @override
  Widget build(BuildContext context) {
    final textStyle = context.typography.subtitle.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: 14.sp,
    );
    return DropdownButtonFormField<T>(
      isExpanded: true,
      value: value,
      validator: validator,
      autovalidateMode: autovalidateMode,
      onChanged: onChanged,
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: context.colors.mainGreenLight,
      ),
      style: textStyle,
      decoration: decoration ??
          InputDecoration(
            hintText: hint,
            labelText: label,
          ),
      dropdownColor: context.colors.white,
      menuMaxHeight: context.mediaQueryHeight * 0.5,
      elevation: 2,
      borderRadius: BorderRadius.circular(AppDimensions.medium),
      items: items.map((e) {
        final isSelected = e == value;
        return DropdownMenuItem<T>(
          value: e,
          child: Text(
            displayString?.call(e) ?? e.toString(),
            style: textStyle.copyWith(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? context.colors.mainGreenLight : null,
            ),
          ),
        );
      }).toList(),
    );
  }
}
