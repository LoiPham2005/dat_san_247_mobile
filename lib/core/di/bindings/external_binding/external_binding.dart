import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dat_san_247_mobile/core/api/dio_client.dart';
import 'package:dat_san_247_mobile/core/lang/language_service.dart';
import 'package:dat_san_247_mobile/core/theme/theme_service.dart';

class ExternalBinding extends Bindings {
  @override
  void dependencies() {
    Get.putAsync<SharedPreferences>(() async {
      return await SharedPreferences.getInstance();
    });

   // Lazy load khi cần
    Get.put<DioClient>(DioClient());

    // theme
    final themeService = Get.put<ThemeService>(ThemeService());
    themeService.loadTheme(); // 🔥 load theme khi start app

    // language
    final languageService = Get.put<LanguageService>(LanguageService());
    languageService.init();
  }
}
