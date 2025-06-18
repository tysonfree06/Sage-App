import 'package:sage/model/user/user_model.dart';

/// Abstract class defining methods for authentication API repositories.
abstract class AuthApiRepository {
  /// Sends a auth request to the authentication API with the provided [data].
  ///
  /// Returns a [UserModel] representing the user data if the auth is successful.
  Future<UserModel> loginApi(dynamic data);
}
