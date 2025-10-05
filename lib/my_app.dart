import 'package:dat_san_247_mobile/core/localization/localization_service.dart';
import 'package:dat_san_247_mobile/core/utils/function/check_internet.dart';
import 'package:dat_san_247_mobile/core/utils/function/check_version.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dat_san_247_mobile/core/di/bindings/initial_binding.dart';
// import 'package:dat_san_247_mobile/core/lang/language_service.dart';
import 'package:dat_san_247_mobile/core/lang/translations.dart';
import 'package:dat_san_247_mobile/core/theme/theme_service.dart';
import 'package:dat_san_247_mobile/features/splash/presentation/pages/splash_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    // final languageService = Get.find<LanguageService>();

    // Check internet & version khi mở app
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 2), () {
        CheckInternet.check(
          Get.context!,
          onConnected: () {
            // Check version khi có internet
            CheckVersion.check(
              Get.context!,
              androidPackageId: 'com.example.dat_san_247_mobile',
              iosBundleId: 'com.example.dat_san_247_mobile',
            );
          },
        );
      });
    });

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SportHub',
      // translations: AppTranslations(),
      // locale: languageService.currentCode,
      // fallbackLocale: const Locale('en', 'US'),
      theme: themeService.currentTheme,
      themeMode: ThemeMode.system,
      // home: const SplashPage(),
      home: const SplashPage(),
    );
  }
}
