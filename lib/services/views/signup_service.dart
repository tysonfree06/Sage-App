import 'package:flutter/cupertino.dart';
import 'package:sage/app/components/my_bottom_sheet.dart';
import 'package:sage/app/routes/routes_name.dart';
import 'package:sage/view/auth/widget/account_verification_sheet.dart';

class SignupService {
  static void showVerificationSheet(
    BuildContext context, {
    String email = 'abc@example.com',
  }) {
    MyBottomSheet.show<void>(
      context,
      child: AccountVerificationSheet(
        email: email,
        onPressed: () {
          Navigator.of(context).pop();
          goToOnBoarding(context);
        },
      ),
    );
  }

  static void goToLogin(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      RoutesName.login,
      (route) => false,
    );
  }

  static void goToOnBoarding(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      RoutesName.onBoarding,
      (route) => false,
    );
  }
}
