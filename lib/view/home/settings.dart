import 'package:flutter/material.dart';
import 'package:sage/app/components/my_text_button.dart';
import 'package:sage/app/routes/routes_name.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MyTextButton(
          label: "Logout",
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              RoutesName.welcome,
              (route) => false,
            );
          },
        ),
      ),
    );
  }
}
