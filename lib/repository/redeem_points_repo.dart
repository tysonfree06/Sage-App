import 'package:sage/app/network/base_api_services.dart';
import 'package:sage/app/network/network_api_services.dart';
import 'package:sage/app/utils/app_url.dart';
import 'package:sage/services/session_manager/session_controller.dart';

final BaseApiServices _apiServices = NetworkApiService();

class RedeemRepository {
  // Future<Map<String, dynamic>> getPoints() async {
  //   return _apiServices.get(
  //     url: AppUrl.getPoints,
  //   );
  // }
  final sessionController = SessionController();

  Future<Map<String, dynamic>> getAvailableOffers() async {
    return _apiServices.get(
      url: AppUrl.availableOffers,
    );
  }

  Future<Map<String, dynamic>> getPastRedemptions() async {
    final userId = sessionController.user!.id;
    return _apiServices.get(
      url: '${AppUrl.pastRedemptions}/?userId=$userId',
    );
  }

  Future<Map<String, dynamic>> redeemOffer(String offerId) async {
    final userId = sessionController.user!.id;
    return _apiServices.post(
      url: AppUrl.redeemOffer,
      data: {
        'userId': userId,
        'offerId': offerId,
      },
    );
  }
}
