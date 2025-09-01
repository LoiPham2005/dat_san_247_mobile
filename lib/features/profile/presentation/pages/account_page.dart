import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dat_san_247_mobile/core/lang/language_service.dart';
import 'package:dat_san_247_mobile/core/lang/locale_keys.dart';
import 'package:dat_san_247_mobile/core/theme/theme_service.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/controller/auth_controller.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:dat_san_247_mobile/core/widgets/toast/show_toast.dart';

class AccountScreen extends StatelessWidget {
  AccountScreen({super.key});

  final AuthController authController = Get.put(AuthController());
  final ThemeService themeService = Get.find<ThemeService>();

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:  Text(LocaleKeys.confirm_logout.tr),
          content:  Text(LocaleKeys.confirm_logout_message.tr),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:  Text(LocaleKeys.cancel.tr),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                authController.logout();
                ShowToast(context, message: LocaleKeys.logout_success.tr);
                Get.offAll(() => LoginPage());
              },
              child:
                  Text(LocaleKeys.logout.tr, style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showThemeBottomSheet() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Get.theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: themeService.themes.keys.map((key) {
            return ListTile(
              title: Text(key),
              trailing: Obx(() => themeService.currentThemeKey == key
                  ? const Icon(Icons.check, color: Colors.green)
                  : const SizedBox()),
              onTap: () {
                themeService.changeTheme(key);
                Get.back(); // đóng bottomsheet
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showLanguageBottomSheet() {
    final languageService = Get.find<LanguageService>();

    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Get.theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: languageService.supportedLocales.keys.map((name) {
            return ListTile(
              title: Text(name),
              trailing: Obx(() => languageService.currentLocale ==
                      languageService.supportedLocales[name]
                  ? const Icon(Icons.check, color: Colors.green)
                  : const SizedBox()),
              onTap: () {
                languageService.changeLocale(name);
                Get.back();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.account.tr)),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _showThemeBottomSheet,
            child: Text(LocaleKeys.theme.tr),
          ).marginOnly(bottom: 20),
          ElevatedButton(
            onPressed: _showLanguageBottomSheet,
            child: Text(LocaleKeys.language.tr),
          ).marginOnly(bottom: 20),
          Obx(() {
            if (authController.userList.isEmpty) {
              return const CircularProgressIndicator();
            }
            return ElevatedButton(
              onPressed: () => _confirmLogout(context),
              child: Text(LocaleKeys.logout),
            );
          }),
        ],
      ),
    );
  }
}
