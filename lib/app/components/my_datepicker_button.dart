import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/components/my_bottom_sheet.dart';
import 'package:sage/app/components/my_button.dart';
import 'package:sage/app/styles/app_dimensions.dart';
import 'package:sage/app/styles/app_radiuses.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/l10n/l10n.dart';

class MyDatePickerButton extends StatelessWidget {
  const MyDatePickerButton({
    required this.hintText,
    required this.selectedDate,
    required this.onChanged,
    super.key,
    this.isExpanded = false,
    this.suffixIcon,
  });
  final String hintText;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onChanged;
  final bool isExpanded;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadiuses.largeRadius),
      borderSide: BorderSide(
        color: selectedDate == null
            ? context.colors.border
            : context.colors.mainGreenLight,
      ),
    );

    final textStyle = context.typography.subtitle.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: 14.sp,
    );

    final child = InkWell(
      onTap: () => _showDatePicker(context),
      borderRadius: BorderRadius.circular(AppRadiuses.largeRadius),
      child: InputDecorator(
        isEmpty: selectedDate == null,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          hintText: hintText,
          hintStyle: textStyle.copyWith(),
          border: border,
          enabledBorder: border,
          focusedBorder: border,
          suffixIcon: suffixIcon,
        ),
        child: selectedDate != null
            ? Text(
          _formatDate(selectedDate!),
          style: textStyle,
        )
            : null,
      ),
    );

    return isExpanded ? Expanded(child: child) : child;
  }

  String _formatDate(DateTime date) {
    // You can customize this
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showDatePicker(BuildContext context) {
    DateTime tempPicked = selectedDate ?? DateTime.now();
    MyBottomSheet.show<void>(
      context,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.medium,
        ),
        child: SizedBox(
          height: 300,
          child: Column(
            children: [
              Expanded(
                child: CupertinoDatePicker(
                  initialDateTime: tempPicked,
                  mode: CupertinoDatePickerMode.date,
                  maximumDate: DateTime(2100),
                  minimumDate: DateTime(1900),
                  onDateTimeChanged: (value) {
                    tempPicked = value;
                  },
                ),
              ),
              MyButton(
                label: context.l10n.done,
                onPressed: () {
                  Navigator.pop(context);
                  onChanged(tempPicked);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
