import 'package:flutter/material.dart';
import 'package:sage/app/components/my_bottom_sheet.dart';
import 'package:sage/app/components/my_button.dart';
import 'package:sage/app/components/status_bar_style.dart';
import 'package:sage/view/onboarding/widgets/location_permission.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return LightStatusBar(
      child: Scaffold(
        body: Center(
          child: MyButton(label: 'Show Location Permission', onPressed: (){
            MyBottomSheet.show<void>(
              context,
              child: LocationPermission(
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            );
          },),
        ),
      ),
    );
  }
}
