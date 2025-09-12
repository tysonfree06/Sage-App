import 'package:flutter/material.dart';
import 'package:sage/app/network/base_api_services.dart';
import 'package:sage/app/network/network_api_services.dart';
import 'package:sage/app/utils/app_url.dart';
import 'package:sage/services/session_manager/session_controller.dart';

class SubscriptionRepository {
  final BaseApiServices _apiServices = NetworkApiService();
  final _sessionController = SessionController();

  Future<Map<String, dynamic>> createPaymentIntent(String priceId) async {
    final userId = _sessionController.user!.id;
    return _apiServices.post(
      url: AppUrl.createPaymentIntent,
      data: {
        'userId': userId,
        'priceId': priceId,
      },
    );
  }

  Future<Map<String, dynamic>> createSubscription(
    String priceId,
    String customerId,
    String setupIntentId,
  ) async {
    debugPrint('->WE ARE IN CREATE SUBSCRIPTION');
    final userId = _sessionController.user!.id;
    return _apiServices.post(
      url: AppUrl.createSubscription,
      data: {
        'userId': userId,
        'priceId': priceId,
        'customerId': customerId,
        'setupIntentId': setupIntentId,
        'platform': 'android',
      },
    );
  }

  Future<Map<String, dynamic>> createAppleSubscription(
    String receiptData,
    String productId,
    String transactionId,
    String purchaseStatus,
  ) async {
    debugPrint('->WE ARE IN CREATE APPLE SUBSCRIPTION');
    final userId = _sessionController.user!.id;
    final Map<String, dynamic> data = {
      'userId': userId,
      'receiptData': receiptData,
      'productId': productId,
      'transactionId': transactionId,
      'originalTransactionId': null,
      'purchaseStatus': purchaseStatus,
      /*initially it's null, but once the
        subscription is created, it will be returned from Apple */
      'environment': 'Sandbox', //Sandbox / TestFlight / Production
      'platform': 'ios',
    };
    debugPrint('SENDING FOLLOWING TRANSACTION DATA TO BACKEND IS: $data');
    return _apiServices.post(
      url: AppUrl.createSubscription,
      data: data,
    );
  }

  //Fetch subscription details
  Future<Map<String, dynamic>> fetchSubscriptionDetails() async {
    final userId = _sessionController.user!.id;
    return _apiServices.get(
      url: '${AppUrl.getSubscriptionDetails}?userId=$userId',
    );
  }

  //Cancel Subscription
  Future<Map<String, dynamic>> cancelSubscription() async {
    final userId = _sessionController.user!.id;
    return _apiServices.post(
      url: AppUrl.cancelSubcription,
      data: {
        'userId': userId,
      },
    );
  }
}
