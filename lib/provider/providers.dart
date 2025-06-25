import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sage/provider/home/navigation_provider.dart';
import 'package:sage/repository/auth_api/auth_api_repository.dart';
import 'package:sage/repository/auth_api/auth_http_api_repository.dart';

final providers = <SingleChildWidget>[
  Provider<AuthApiRepository>(
    create: (_) => AuthHttpApiRepository(),
  ),
  ChangeNotifierProvider(create: (_) => NavigationProvider()),
  // Add more providers here
];
