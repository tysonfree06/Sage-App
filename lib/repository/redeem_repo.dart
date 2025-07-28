import 'package:sage/app/network/base_api_services.dart';
import 'package:sage/app/network/network_api_services.dart';
import 'package:sage/app/utils/app_url.dart';

final BaseApiServices _apiServices = NetworkApiService();

class RedeemRepository {
  Future<Map<String, dynamic>> getPoints() async {
    return _apiServices.get(
      url: AppUrl.getPoints,
    );
  }
}
