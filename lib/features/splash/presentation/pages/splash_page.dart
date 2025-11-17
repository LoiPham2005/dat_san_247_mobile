import 'package:dat_san_247_mobile/core/utils/function/check_internet.dart';
import 'package:dat_san_247_mobile/core/utils/function/check_version.dart';
import 'package:dat_san_247_mobile/core/utils/shared_preferences/app_preferences.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dat_san_247_mobile/core/utils/shared_preferences/db_keys_local.dart';
import 'package:dat_san_247_mobile/core/utils/shared_preferences/share_pref.dart';
import 'package:dat_san_247_mobile/features/bottomMenu/screens/bottom_menu_custom.dart';
import 'package:dat_san_247_mobile/features/intro/presentation/pages/welcome_page.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  Future<void> _initializeApp(BuildContext context) async {
    try {
      // Check internet trước
      final hasInternet = await CheckInternet.hasConnection();
      if (!hasInternet) {
        await CheckInternet.check(
          context,
          showMessage: true,
          onConnected: () async {
            // Tiếp tục khởi tạo khi có internet
            await _continueInitialization(context);
          },
        );
      } else {
        // Có internet, tiếp tục khởi tạo
        await _continueInitialization(context);
      }
    } catch (e) {
      print("Error initializing app: $e");
      // Fallback nếu có lỗi
      await _continueInitialization(context);
    }
  }

  Future<void> _continueInitialization(BuildContext context) async {
    try {
      // Check version
      await CheckVersion.check(
        context,
        androidPackageId: 'com.example.dat_san_247_mobile',
        iosBundleId: 'com.example.dat_san_247_mobile',
      );

      final firstRun = await AppPreferences.isFirstRun();
      final loggedIn = await AppPreferences.isLogin();

      print("isFirstRun: $firstRun");
      print("isLogin: $loggedIn");

      if (firstRun) {
        Get.offAll(() => WelcomePage());
      } else {
        if (loggedIn) {
          Get.offAll(() => BottomMenuCustom());
        } else {
          Get.offAll(() => LoginPage());
        }
      }
    } catch (e) {
      print("Error in continuation: $e");
      // Fallback về login page nếu có lỗi
      Get.offAll(() => LoginPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    // Khởi tạo app sau khi build hoàn tất
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp(context);
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/image/SprotHub_Logo.png',
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
