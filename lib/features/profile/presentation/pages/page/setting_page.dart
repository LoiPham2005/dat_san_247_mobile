import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dat_san_247_mobile/core/theme/theme_service.dart';
import 'package:dat_san_247_mobile/core/localization/localization_service.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    final localizationService = Get.find<LocalizationService>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xff62b766).withOpacity(0.1),
              Colors.white,
              Color(0xff4fa553).withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xff62b766), Color(0xff4fa553)],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.settings,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Cài đặt",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff2d5533),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),

                // Card chọn giao diện
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 3,
                  child: ListTile(
                    leading: Icon(Icons.color_lens, color: Color(0xff62b766)),
                    title: Text(
                      "Chọn giao diện",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                      color: Colors.grey[400],
                    ),
                    onTap: () {
                      Get.bottomSheet(
                        Container(
                          decoration: BoxDecoration(
                            color: Get.theme.scaffoldBackgroundColor,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: themeService.themes.keys.map((key) {
                              return ListTile(
                                title: Text(key.toString().split('.').last),
                                trailing: Obx(
                                  () => themeService.currentThemeKey == key
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.green,
                                        )
                                      : const SizedBox(),
                                ),
                                onTap: () {
                                  themeService.changeTheme(key);
                                  Get.back();
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 16),

                // Card chọn ngôn ngữ
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 3,
                  child: ListTile(
                    leading: Icon(Icons.language, color: Colors.blue),
                    title: Text(
                      "Chọn ngôn ngữ",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                      color: Colors.grey[400],
                    ),
                    onTap: () {
                      Get.bottomSheet(
                        Obx(
                          () => Container(
                            decoration: BoxDecoration(
                              color: Get.theme.scaffoldBackgroundColor,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: localizationService
                                  .supportedLocales
                                  .keys
                                  .map((name) {
                                    return ListTile(
                                      title: Text(name),
                                      trailing:
                                          localizationService
                                                  .currentLanguageName ==
                                              name
                                          ? const Icon(
                                              Icons.check,
                                              color: Colors.green,
                                            )
                                          : const SizedBox(),
                                      onTap: () async {
                                        await localizationService.changeLocale(
                                          name,
                                        );
                                        Get.back();
                                      },
                                    );
                                  })
                                  .toList(),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
