import 'package:dokuro_flutter/services/auth_service.dart';
import 'package:dokuro_flutter/services/db_service.dart';
import 'package:dokuro_flutter/services/notification_service.dart';
import 'package:dokuro_flutter/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:dokuro_flutter/services/theme/theme_service.dart';
import 'package:dokuro_flutter/services/theme/themes.dart';
import 'screens/auth_splash.dart';

Future<void> main() async {
  await initOnceForEver();
  runApp(const MyApp());
}

Future<void> initOnceForEver() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
}

Future<void> initServices() async {
  debugPrint('starting services ...');
  //await 2.delay();
  await Get.putAsync(() => StorageService().initPlz());
  await Get.putAsync(() => DbService().initPlz());
  await Get.putAsync(() => AuthService().initPlz());
  await Get.putAsync(() => NotificationService().initPlz());
  debugPrint('All services started...');
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
