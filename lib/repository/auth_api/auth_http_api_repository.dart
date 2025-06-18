import 'package:sage/app/network/base_api_services.dart';
import 'package:sage/app/network/network_api_services.dart';
import 'package:sage/app/utils/app_url.dart';
import 'package:sage/model/user/user_model.dart';
import 'package:sage/repository/auth_api/auth_api_repository.dart';

/// Implementation of [AuthApiRepository] for making HTTP requests to the authentication API.
class AuthHttpApiRepository implements AuthApiRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  /// Sends a auth request to the authentication API with the provided [data].
  ///
  /// Returns a [UserModel] representing the user data if the auth is successful.
  @override
  Future<UserModel> loginApi(dynamic data) async {
    final dynamic response =
        await _apiServices.postApi(AppUrl.loginEndPint, data);
    return UserModel.fromJson(response as Map<String, dynamic>);
  }
}
