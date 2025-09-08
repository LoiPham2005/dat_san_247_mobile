// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class LanguageService extends GetxService {
//   static const String languageKey = "selectedLanguage";

//   final _currentLocale = const Locale('en', 'US').obs;
//   Locale get currentLocale => _currentLocale.value;

//   final supportedLocales = const {
//     "English": Locale('en', 'US'),
//     "Tiếng Việt": Locale('vi', 'VN'),
//     "日本語": Locale('ja', 'JP'),
//   };

//   late SharedPreferences prefs;

//   Future<LanguageService> init() async {
//     prefs = await SharedPreferences.getInstance();
//     String? saved = prefs.getString(languageKey);
//     if (saved != null) {
//       List<String> parts = saved.split('_');
//       _currentLocale.value = Locale(parts[0], parts[1]);
//       Get.updateLocale(_currentLocale.value);
//     }
//     return this;
//   }

//   Future<void> changeLocale(String name) async {
//     Locale locale = supportedLocales[name]!;
//     _currentLocale.value = locale;
//     await prefs.setString(
//       languageKey,
//       "${locale.languageCode}_${locale.countryCode}",
//     );
//     Get.updateLocale(locale);
//   }
// }
