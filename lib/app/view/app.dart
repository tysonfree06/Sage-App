import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sage/app/routes/routes.dart';
import 'package:sage/app/styles/app_dimensions.dart';
import 'package:sage/app/styles/theme_factory.dart';
import 'package:sage/l10n/arb/app_localizations.dart';
import 'package:sage/provider/providers.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: AppDimensions.mockSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: providers,
          child: MaterialApp(
            title: 'Sage',
            themeMode: ThemeMode.light,
            theme: ThemeFactory.lightThemeData(),
            darkTheme: ThemeFactory.lightThemeData(),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            initialRoute: Routes.initialRoute(),
            onGenerateRoute: Routes.generateRoute,
          ),
        );
      },
    );
  }
}
