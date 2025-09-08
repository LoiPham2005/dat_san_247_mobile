// lib/core/localization/app_localization.dart
import 'package:get/get.dart';
import 'package:dat_san_247_mobile/core/localization/locale_keys.dart';
import 'languages/en.dart';
import 'languages/vi.dart';
import 'languages/jp.dart';

class Language {
  // Sử dụng Rx<LocaleKeys> thay vì khởi tạo với ViLocale
  static final Rx<LocaleKeys> _current = Rx<LocaleKeys>(ViLocale());

  // Getter để access current locale
  static LocaleKeys get current => _current.value;

  // Method để thay đổi ngôn ngữ và trigger reactive update
  static void changeLanguage(String code) {
    LocaleKeys newLocale;
    switch (code) {
      case 'en':
        newLocale = EnLocale();
        break;
      case 'jp':
        newLocale = JpLocale();
        break;
      default:
        newLocale = ViLocale();
    }
    _current.value = newLocale;
  }

  // Method để lắng nghe thay đổi (nếu cần)
  static Rx<LocaleKeys> get currentRx => _current;
}
