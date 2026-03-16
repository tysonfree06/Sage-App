import 'package:flutter/material.dart';
import 'package:sage/app/network/base_api_services.dart';
import 'package:sage/app/network/network_api_services.dart';
import 'package:sage/app/utils/app_url.dart';
import 'package:sage/services/session_manager/session_controller.dart';

class AuthRepository {
  final BaseApiServices _apiServices = NetworkApiService();
  final SessionController _sessionController = SessionController();

  Future<Map<String, dynamic>> login(Map<String, dynamic> data) async {
    return _apiServices.post(
      url: AppUrl.login,
      data: data,
    );
  }

  Future<Map<String, dynamic>> getCurrentUserProfile() async {
    return _apiServices.get(
      url: AppUrl.getMeUser,
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
    debugPrint('verifyOtp called with data: $data'); //#muttas
    return _apiServices.post(
      url: AppUrl.verifyOtp,
      data: data,
    );
  }

  Future<Map<String, dynamic>> verifyResetOtp(Map<String, dynamic> data) async {
    debugPrint('verifyResetOtp called with data: $data'); //#muttas
    return _apiServices.post(
      url: AppUrl.verifyResetOtp,
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

  Future<Map<String, dynamic>> deleteUser(Map<String, dynamic> data) async {
    return _apiServices.delete(
      url: AppUrl.deleteAccount,
      data: {
        'userId': _sessionController.user?.id ?? '',
      },
    );
  }

  // Fetches the partner details from the server
  Future<Map<String, dynamic>> getPartner(dynamic partnerCode) async {
    return _apiServices.get(
      url: '${AppUrl.getPartner}?partnerCode=$partnerCode',
    );
  }

  Future<Map<String, dynamic>> removePartner(Map<String, dynamic> data) async {
    return _apiServices.delete(
      url: AppUrl.removePartner,
      data: {
        'userId': _sessionController.user?.id ?? '',
      },
    );
  }
}
