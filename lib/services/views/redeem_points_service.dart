import 'package:flutter/material.dart';
import 'package:sage/app/routes/routes_name.dart';

class RedeemPointsService {
  static void goToInvite(BuildContext context) {
    Navigator.pushNamed(
      context,
      RoutesName.invite,
    );
  }

  static void goToDetailScreen(BuildContext context) {
    Navigator.pushNamed(
      context,
      RoutesName.redeemOfferDetail,
    );
  }
}
