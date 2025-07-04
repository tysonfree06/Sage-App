import 'package:flutter/material.dart';
import 'package:sage/app/routes/routes_name.dart';
import 'package:sage/model/redeem/radeem_model.dart';

class RedeemPointsService {
  static void goToInvite(BuildContext context) {
    Navigator.pushNamed(
      context,
      RoutesName.invitation,
    );
  }

  static void goToDetailScreen(BuildContext context, RedeemOfferDetails offer ) {
    Navigator.pushNamed(
      context,
      RoutesName.offerDetail,
      arguments: offer,
    );
  }
}
