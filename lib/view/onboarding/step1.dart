import 'package:flutter/material.dart';
import 'package:sage/app/components/my_dropdown.dart';

class Step1Screen extends StatefulWidget {
  const Step1Screen({super.key});

  @override
  State<Step1Screen> createState() => _Step1ScreenState();
}

class _Step1ScreenState extends State<Step1Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          ],
        ),
      ),
    );
  }
}
