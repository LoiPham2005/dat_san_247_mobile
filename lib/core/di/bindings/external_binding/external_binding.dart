import 'package:dat_san_247_mobile/core/localization/localization_service.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dat_san_247_mobile/core/api/dio_client.dart';
import 'package:dat_san_247_mobile/core/lang/language_service.dart' hide LanguageService;
import 'package:dat_san_247_mobile/core/theme/theme_service.dart';

class ExternalBinding implements Bindings {
  @override
  Future<void> dependencies() async {
    // Core services first
    final sharedPrefs = await SharedPreferences.getInstance();
    Get.put(sharedPrefs, permanent: true);

    // DioClient depends on SharedPreferences
    final dioClient = DioClient();
    Get.put(dioClient, permanent: true);

    // App services
    final themeService = ThemeService();
    Get.put(themeService, permanent: true);
    await themeService.loadTheme();

    // final langService = LanguageService();
    // Get.put(langService, permanent: true);
    // await langService.init();

    final localizationService = LocalizationService();
    Get.put(localizationService, permanent: true);
    await localizationService.init();
  }
}
