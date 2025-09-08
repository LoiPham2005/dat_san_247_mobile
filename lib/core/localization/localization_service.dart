// lib/core/lang/language_service.dart
import 'package:dat_san_247_mobile/core/localization/locale_keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../localization/app_localization.dart';

class LocalizationService extends GetxService {
  static const String languageKey = "selectedLanguage";

  // Sử dụng AppLocalization's reactive current
  LocaleKeys get currentLocale => Language.current;
  
  late SharedPreferences prefs;

  final Map<String, String> supportedLocales = {
    'Tiếng Việt': 'vi',
    'English': 'en',
    'Japanese': 'jp',
  };

  /// Khởi tạo service và load ngôn ngữ đã lưu
  Future<LocalizationService> init() async {
    prefs = await SharedPreferences.getInstance();
    String? saved = prefs.getString(languageKey);
    if (saved != null && supportedLocales.containsValue(saved)) {
      Language.changeLanguage(saved);
    } else {
      Language.changeLanguage('vi'); // default
    }
    return this;
  }

  /// Thay đổi ngôn ngữ
  Future<void> changeLocale(String name) async {
    final code = supportedLocales[name] ?? 'vi';
    Language.changeLanguage(code);
    await prefs.setString(languageKey, code);
  }
  
  /// Get current language name
  String get currentLanguageName {
    final code = supportedLocales.values.firstWhere(
      (value) => _isCurrentLanguage(value),
      orElse: () => 'vi',
    );
    return supportedLocales.entries
        .firstWhere((entry) => entry.value == code)
        .key;
  }
  
  bool _isCurrentLanguage(String code) {
    switch (code) {
      case 'en':
        return currentLocale.runtimeType.toString() == 'EnLocale';
      case 'jp':
        return currentLocale.runtimeType.toString() == 'JpLocale';
      default:
        return currentLocale.runtimeType.toString() == 'ViLocale';
    }
  }
}