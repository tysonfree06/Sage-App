import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sage/app/components/my_bottom_sheet.dart';
import 'package:sage/app/components/my_button.dart';
import 'package:sage/app/styles/app_dimensions.dart';
import 'package:sage/app/styles/app_radiuses.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';

class MyDatePickerButton extends StatelessWidget {
  final String hintText;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onChanged;
  final bool isExpanded;
  final Widget? suffixIcon;

  const MyDatePickerButton({
    required this.hintText,
    required this.selectedDate,
    required this.onChanged,
    super.key,
    this.isExpanded = false,
    this.suffixIcon,
  });

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

    final textStyle = context.typography.body.copyWith();

    final child = InkWell(
      onTap: () => _showDatePicker(context),
      borderRadius: BorderRadius.circular(AppRadiuses.largeRadius),
      child: InputDecorator(
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          hintText: hintText,
          hintStyle: textStyle.copyWith(color: Colors.blue),
          border: border,
          enabledBorder: border,
          focusedBorder: border,
          suffixIcon: suffixIcon,
        ),
        child: Text(
          selectedDate != null ? _formatDate(selectedDate!) : '',
          style: textStyle,
        ),
      ),
    );

    return isExpanded ? Expanded(child: child) : child;
  }

  String _formatDate(DateTime date) {
    // You can customize this
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showDatePicker(BuildContext context) {
//     The type argument(s) of the function 'showModalBottomSheet' can't be inferred.
// Use explicit type argument(s) for 'showModalBottomSheet'.
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
                label: 'Done',
                onPressed: () {
                  Navigator.pop(context);
                  onChanged(tempPicked);
                },
              ),
            ],
          ),
        ),
      ),
      // context: context,
      // builder: (ctx) {
      //   DateTime tempPicked = selectedDate ?? DateTime.now();

      //   return SizedBox(
      //     height: 300,
      //     child: Column(
      //       children: [
      //         Expanded(
      //           child: CupertinoDatePicker(
      //             initialDateTime: tempPicked,
      //             mode: CupertinoDatePickerMode.date,
      //             maximumDate: DateTime(2100),
      //             minimumDate: DateTime(1900),
      //             onDateTimeChanged: (value) {
      //               tempPicked = value;
      //             },
      //           ),
      //         ),
      //         MyButton(
      //           label: "Done",
      //           onPressed: () {
      //             Navigator.pop(ctx);
      //             onChanged(tempPicked);
      //           },
      //         )
      //       ],
      //     ),
      //   );
      // },
    );
  }
}
