import 'package:sage/app/network/base_api_services.dart';
import 'package:sage/app/network/network_api_services.dart';
import 'package:sage/app/utils/app_url.dart';

class AuthRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<Map<String, dynamic>> login(Map<String, dynamic> data) async {
    return _apiServices.post(
      url: AppUrl.login,
      data: data,
    );
  }

  Future<Map<String, dynamic>> signup(Map<String, dynamic> data) async {
    return _apiServices.post(
      url: AppUrl.signup,
      data: data,
    );
  }

  Future<Map<String, dynamic>> sendOtp(Map<String, dynamic> data) async {
    return _apiServices.post(
      url: AppUrl.sendOtp,
      data: data,
    );
  }
  Future<Map<String, dynamic>> verifyOtp(Map<String, dynamic> data) async {
    return _apiServices.post(
      url: AppUrl.verifyOtp,
      data: data,
    );
  }
  Future<Map<String, dynamic>> forgotPassword(Map<String, dynamic> data) async {
    return _apiServices.post(
      url: AppUrl.forgotPassword,
      data: data,
    );
  }
  Future<Map<String, dynamic>> resetPassword(Map<String, dynamic> data) async {
    return _apiServices.post(
      url: AppUrl.resetPassword,
      data: data,
    );
  }
}
