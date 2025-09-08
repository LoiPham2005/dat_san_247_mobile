import 'package:dat_san_247_mobile/core/localization/localization_service.dart';
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

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App',
      // translations: AppTranslations(),
      // locale: languageService.currentCode,
      // fallbackLocale: const Locale('en', 'US'),
      theme: themeService.currentTheme,
      themeMode: ThemeMode.system,
      home: const SplashPage(),
    );
  }
}
