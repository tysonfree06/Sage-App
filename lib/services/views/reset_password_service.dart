import 'package:flutter/cupertino.dart';
import 'package:sage/app/routes/routes_name.dart';

class ResetPasswordService {
  static void goToLogin(
    BuildContext context,
  ) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      RoutesName.login,
      (route) => false,
    );
  }
}
