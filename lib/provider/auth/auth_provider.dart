// import 'package:flutter/foundation.dart';
// import 'package:sage/model/user/user_model.dart';
// import 'package:sage/repository/auth/auth_repo.dart';

// class AuthProvider with ChangeNotifier {
//   final AuthRepository _authRepository = AuthRepository();

//   UserModel? _user;
//   UserModel? get user => _user;

//   Future<void> login(Map<String, dynamic> data) async {
//     _user = await _authRepository.login(data);
//     notifyListeners();
//   }
// }
