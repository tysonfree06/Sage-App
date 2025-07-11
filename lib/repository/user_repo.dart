import 'package:sage/app/network/base_api_services.dart';
import 'package:sage/app/network/network_api_services.dart';
import 'package:sage/app/utils/app_url.dart';

class UserRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    return _apiServices.put(
      url: AppUrl.profileUpdate,
      data: data,
    );
  }

  Future<Map<String, dynamic>> updatePassword(Map<String, dynamic> data) async {
    return _apiServices.put(
      url: AppUrl.updatePassword,
      data: data,
    );
  }
}
