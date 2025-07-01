import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sage/provider/home/navigation_provider.dart';

final providers = <SingleChildWidget>[
  ChangeNotifierProvider(create: (_) => NavigationProvider()),
  // Add more providers here
];
