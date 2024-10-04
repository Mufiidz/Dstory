import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:flutter/material.dart';

import 'di/injection.dart';
import 'screen/splash/splash_screen.dart';
import 'utils/export_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait(<Future<void>>[
    setupDI(),
    EasyLocalization.ensureInitialized(),
  ]);
  runApp(EasyLocalization(
    supportedLocales: const <Locale>[
      Locale('id'),
      Locale('en'),
    ],
    path: 'assets/translations',
    fallbackLocale: const Locale('en'),
    startLocale: const Locale('id'),
    assetLoader: const JsonAssetLoader(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constant.appName,
      navigatorKey: AppRoute.navigatorKey,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
