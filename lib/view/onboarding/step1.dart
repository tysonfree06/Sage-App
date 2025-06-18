import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sage/app/components/my_dropdown.dart';
import 'package:sage/app/components/step_progress_bar.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/app/utils/extensions/general_extensions.dart';

class Step1Screen extends StatefulWidget {
  const Step1Screen({super.key});

  @override
  State<Step1Screen> createState() => _Step1ScreenState();
}

class _Step1ScreenState extends State<Step1Screen> {
  @override
  Widget build(BuildContext context) {
    DateTime selectedDate = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: context.colors.mainGreenLight),
        title: SizedBox(
          width: context.mediaQueryWidth / 2,
          child: const StepProgressBar(totalSteps: 4, currentStep: 0),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            MyDropdown(
              items: ["a", 'b', 'c'],
              value: 'a',
              onChanged: (value) {},
              hint: "Words Of Affirmation",
              displayString: (item) => item.toString(),
            ),
            SizedBox(
              height: 200,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: selectedDate,
                minimumDate: DateTime(1900),
                maximumDate: DateTime(2100),
                onDateTimeChanged: (DateTime newDate) {
                  print('Selected: $newDate');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
