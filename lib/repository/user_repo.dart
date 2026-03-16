import 'package:sage/app/network/base_api_services.dart';
import 'package:sage/app/network/network_api_services.dart';
import 'package:sage/app/utils/app_url.dart';
import 'package:sage/services/session_manager/session_controller.dart';

class UserRepository {
  final BaseApiServices _apiServices = NetworkApiService();
  final _sessionController = SessionController();

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

  Future<Map<String, dynamic>> fetchRelationshipSuggestion() async {
    final String userId = _sessionController.user!.id;
    return _apiServices.post(
      url: AppUrl.relationshipSuggestion,
      data: {
        'userId': userId,
      },
    );
  }
}
