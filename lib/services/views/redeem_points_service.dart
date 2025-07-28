import 'package:flutter/material.dart';
import 'package:sage/app/data/exception/app_exceptions.dart';
import 'package:sage/app/routes/routes_name.dart';
import 'package:sage/model/redeem/redeem_model.dart';
import 'package:sage/repository/redeem_repo.dart';

RedeemRepository _redeemRepository = RedeemRepository();

class RedeemPointsService {
  static void goToInvite(BuildContext context) {
    Navigator.pushNamed(
      context,
      RoutesName.invitation,
    );
  }

  //FIXME: Remove this comment after generated files fix #muttas
  static void goToDetailScreen(BuildContext context, RedeemOfferDetails offer) {
    Navigator.pushNamed(
      context,
      RoutesName.offerDetail,
      arguments: offer,
    );
  }

  //get points
  Future<String> getPoints() async {
    try {
      final response = await _redeemRepository.getPoints();
      return response['points'] as String;
    } catch (e) {
      if (e is AppException) {
        debugPrint('[RedeemService] ❌ ${e.debugMessage}');
      } else {
        debugPrint('[SettingRedeemServiceService] ❌ Unexpected: $e');
      }
    }
    return '';
  }
}
