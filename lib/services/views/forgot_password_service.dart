import 'package:flutter/cupertino.dart';
import 'package:sage/app/routes/routes_name.dart';

class ForgotPasswordService {
  static void goToResetPassword(
    BuildContext context,
  ) {
    Navigator.pushNamed(
      context,
      RoutesName.resetPassword,
    );
  }
}
