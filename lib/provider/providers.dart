import 'package:sage/repository/auth_api/auth_api_repository.dart';
import 'package:sage/repository/auth_api/auth_http_api_repository.dart';
import 'package:provider/provider.dart';

final providers = <Provider<dynamic>>[
  Provider<AuthApiRepository>(
    create: (_) => AuthHttpApiRepository(),
  ),
  // Add more providers here
];
