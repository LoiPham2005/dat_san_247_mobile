import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:dat_san_247_mobile/core/di/bindings/initial_binding.dart';
import 'package:dat_san_247_mobile/core/lang/language_service.dart';
import 'package:dat_san_247_mobile/core/lang/translations.dart';
import 'package:dat_san_247_mobile/core/theme/app_theme.dart';
import 'package:dat_san_247_mobile/core/theme/theme_service.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:dat_san_247_mobile/features/bottomMenu/screens/bottom_menu_custom.dart';
import 'package:dat_san_247_mobile/features/bottomMenu/screens/botttom_menu.dart';
import 'package:dat_san_247_mobile/features/intro/screens/welcome_screen.dart';
import 'package:dat_san_247_mobile/features/splash/presentation/pages/splash_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeService themeService = Get.put(ThemeService());
    final LanguageService languageService = Get.put(LanguageService());

    // có thể chọn nhiều theme
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App',
      translations: AppTranslations(),
      locale: languageService.currentLocale,
      fallbackLocale: const Locale('en', 'US'),
      theme: themeService.currentTheme, // 👉 lấy theme hiện tại
      themeMode: ThemeMode.system,
      initialBinding: InitialBinding(),
      home: SplashPage(),
    );
  }
}
