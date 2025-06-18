import 'package:sage/model/user/user_model.dart';
import 'package:sage/repository/auth_api/auth_api_repository.dart';

/// Mock implementation of [AuthApiRepository] for simulating auth requests.
class AuthMockApiRepository implements AuthApiRepository {
  @override
  Future<UserModel> loginApi(dynamic data) async {
    // Simulate a delay to mimic network latency
    await Future<dynamic>.delayed(const Duration(seconds: 2));
    // Mock response data
    final responseData = {'token': 'a23z345xert'};
    return UserModel.fromJson(responseData);
  }
}
