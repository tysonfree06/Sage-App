import 'package:flutter/material.dart';
import 'package:sage/app/data/exception/app_exceptions.dart';
import 'package:sage/app/routes/routes_name.dart';
import 'package:sage/app/utils/extensions/flush_bar_extension.dart';
import 'package:sage/model/redeem/redeem_model.dart';
import 'package:sage/repository/redeem_points_repo.dart';
import 'package:sage/services/views/splash_services.dart';

RedeemRepository _redeemRepository = RedeemRepository();

class RedeemPointsService {
  static void goToInvite(BuildContext context) {
    Navigator.pushNamed(
      context,
      RoutesName.invitation,
    );
  }

  static Future<void> goToDetailScreen(
    BuildContext context,
    RedeemOfferDetails offer,
  ) async {
    await Navigator.pushNamed(
      context,
      RoutesName.offerDetail,
      arguments: offer,
    );
  }

  //get available offers
  static Future<Map<String, dynamic>> getAvailableOffers() async {
    try {
      final response = await _redeemRepository.getAvailableOffers();
      debugPrint('✅ AVAILABLE OFFERS  FETCHED: $response');
      return response;
    } catch (e) {
      if (e is AppException) {
        debugPrint('[PointsService] ❌ ${e.debugMessage}');
      } else {
        debugPrint('[PointsService] ❌ Unexpected: $e');
      }
    }
    return {};
  }

  //get past redemptions
  static Future<Map<String, dynamic>> getPastRedemptions() async {
    try {
      final response = await _redeemRepository.getPastRedemptions();
      debugPrint('✅ AVAILABLE OFFERS  FETCHED: $response');
      return response;
    } catch (e) {
      if (e is AppException) {
        debugPrint('[PointsService] ❌ ${e.debugMessage}');
      } else {
        debugPrint('[PointsService] ❌ Unexpected: $e');
      }
    }
    return {};
  }

  //get past redemptions
  static Future<void> redeemOffer(BuildContext context, String offerId) async {
    try {
      final response = await _redeemRepository.redeemOffer(offerId);
      if (context.mounted) {
        await SplashServices().fetchProfile(context);
      }
      debugPrint('✅ AVAILABLE OFFERS  FETCHED: $response');
      if (context.mounted) {
        context.flushBarSuccessMessage(message: 'Redemption Successful!');
      }
    } catch (e) {
      if (e is AppException) {
        debugPrint('[PointsService] ❌ ${e.debugMessage}');
        if (context.mounted) {
          context.flushBarErrorMessage(message: e.userMessage);
        }
      } else {
        debugPrint('[PointsService] ❌ Unexpected: $e');
        if (context.mounted) {
          context.flushBarErrorMessage(message: 'Something went wrong...');
        }
      }
    }
  }
}
