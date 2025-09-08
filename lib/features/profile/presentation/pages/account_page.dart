import 'package:dat_san_247_mobile/core/localization/app_localization.dart';
import 'package:dat_san_247_mobile/core/localization/localization_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:dat_san_247_mobile/core/lang/language_service.dart';
import 'package:dat_san_247_mobile/core/theme/theme_service.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/controller/auth_controller.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:dat_san_247_mobile/core/widgets/toast/show_toast.dart';

class AccountScreen extends StatelessWidget {
  AccountScreen({super.key});

  final AuthController authController = Get.put(AuthController());
  final ThemeService themeService = Get.find<ThemeService>();
  final LocalizationService localizationService =
      Get.find<LocalizationService>();

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Obx(
          () => AlertDialog(
            title: Text(Language.current.confirmLogout),
            content: Text(Language.current.confirmLogoutMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(Language.current.cancel),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  authController.logout();
                  ShowToast(context, message: Language.current.logoutSuccess);
                  Get.offAll(() => LoginPage());
                },
                child: Text(
                  Language.current.logout,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
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
              title: Text(
                key.toString().split('.').last,
              ), // hiển thị Light, Dark...
              trailing: Obx(
                () => themeService.currentThemeKey == key
                    ? const Icon(Icons.check, color: Colors.green)
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
  }

  void _showLanguageBottomSheet() {
    Get.bottomSheet(
      Obx(
        () => Container(
          decoration: BoxDecoration(
            color: Get.theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: localizationService.supportedLocales.keys.map((name) {
              return ListTile(
                title: Text(name),
                trailing: localizationService.currentLanguageName == name
                    ? const Icon(Icons.check, color: Colors.green)
                    : const SizedBox(),
                // trailing: Obx(() {
                //   final current = Get.find<LanguageService>().currentLocale;
                //   return Text(current.theme);
                // }),
                onTap: () async {
                  await localizationService.changeLocale(name);
                  Get.back();
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Obx(() => Text(Language.current.account))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _showThemeBottomSheet,
              child: Obx(() => Text(Language.current.theme)),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _showLanguageBottomSheet,
              child: Obx(() => Text(Language.current.language)),
            ),
            const SizedBox(height: 16),
            Obx(() {
              if (authController.userList.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              return ElevatedButton(
                onPressed: () => _confirmLogout(context),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                ),
                child: Text(Language.current.logout),
              );
            }),
          ],
        ),
      ),
    );
  }
}
