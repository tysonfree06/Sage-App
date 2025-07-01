import 'package:flutter/material.dart';
import 'package:sage/app/routes/routes_name.dart';

class SettingService {
  static Future<void> goToEditProfileScreen(BuildContext context) async {}

  static Future<void> goToChangePasswordScreen(BuildContext context) async {
    await Navigator.pushNamed(
      context,
      RoutesName.changePassword,
    );
  }
}
