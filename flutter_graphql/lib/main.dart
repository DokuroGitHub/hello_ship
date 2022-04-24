import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_graphql/services/theme/theme_service.dart';
import 'package:flutter_graphql/services/theme/themes.dart';
import 'screens/auth_splash.dart';

Future<void> initOnceForEver() async {
  //TODO: init shared preferences
  //await sharedPreferencesService.getSharedPreferencesInstance();
}

Future<void> main() async {
  initOnceForEver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeService().theme,
      home: const AuthSplash(),
    );
  }
}
