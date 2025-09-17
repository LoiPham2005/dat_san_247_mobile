import 'package:dat_san_247_mobile/core/localization/app_localization.dart';
import 'package:dat_san_247_mobile/core/localization/localization_service.dart';
import 'package:dat_san_247_mobile/core/utils/extensions/int_ext.dart';
import 'package:dat_san_247_mobile/core/widgets/custom_image.dart';
import 'package:dat_san_247_mobile/features/profile/presentation/pages/page/edit_profile_page.dart';
import 'package:dat_san_247_mobile/features/profile/presentation/pages/page/setting_page.dart';
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

  final List<Map<String, dynamic>> items = [
    {"title": "Tài khoản", "icon": Icons.person},
    {"title": "Đơn hàng", "icon": Icons.shopping_bag},
    {"title": "Yêu thích", "icon": Icons.favorite},
    {"title": "Địa chỉ", "icon": Icons.location_on},
    {"title": "Thanh toán", "icon": Icons.payment},
    {"title": "Thông báo", "icon": Icons.notifications},
    {"title": "Cài đặt", "icon": Icons.settings},
    {"title": "Trợ giúp", "icon": Icons.help},
    {"title": "Về chúng tôi", "icon": Icons.info},
  ];

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(Language.current.confirmLogout),
          content: Text(Language.current.confirmLogoutMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(Language.current.cancel),
            ),
            TextButton(
              onPressed: () {
                authController
                    .logout()
                    .then((_) {
                      Get.offAll(() => LoginPage());
                      Get.snackbar('Success', Language.current.logoutSuccess);
                    })
                    .catchError((error) {
                      Get.snackbar(
                        'Error',
                        Language.current.logoutFailed,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    });
              },
              child: Text(
                Language.current.logout,
                style: const TextStyle(color: Colors.red),
              ),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
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
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
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
                            colors: [
                              // Color(0xff62b766),
                              //  Color(0xff4fa553)
                              colorScheme.primary,
                              colorScheme.primaryContainer
                               ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Thông tin cá nhân",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff2d5533),
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.edit, color: Color(0xff62b766)),
                        onPressed: () {
                          Get.to(() => const EditProfilePage());
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  // Profile Card
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CustomImage(
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                          radius: 30,
                          imageUrl:
                              "https://photo.znews.vn/w660/Uploaded/mdf_eioxrd/2021_07_06/2.jpg",
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'phamducloi',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff2d5533),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'phamducloi919@gmail.com',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),

                  // Menu
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: ListTile(
                          leading: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xff62b766), Color(0xff4fa553)],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            width: 36,
                            height: 36,
                            child: Icon(
                              item["icon"] as IconData,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            item["title"] as String,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color(0xff2d5533),
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 18,
                            color: Colors.grey[400],
                          ),
                          onTap: () {
                            if (item["title"] == "Cài đặt") {
                              Get.to(() => SettingPage());
                            }
                            // Các xử lý khác...
                          },
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 24),

                  // Logout button
                  Center(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                      ),
                      icon: Icon(Icons.logout),
                      label: Text(
                        "Đăng xuất",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        _confirmLogout(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
