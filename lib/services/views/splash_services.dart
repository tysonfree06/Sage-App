import 'dart:async'; // Importing dart:async for asynchronous operations
import 'package:flutter/material.dart'; // Importing Flutter material library
import 'package:sage/app/routes/routes_name.dart';

class SplashServices {
  Future<void> checkAuthentication(BuildContext context) async {
    //TODO: Login using token and on failure go to welcome screen (on token) / login screen (token not working)
  }

  Future<void> goToWelcome(BuildContext context) async {
    Timer(
      const Duration(seconds: 2),
      () => Navigator.pushNamedAndRemoveUntil(
        context,
        RoutesName.welcome,
        (route) => false,
      ),
    );
  }
}
