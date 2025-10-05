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

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 1000), () async {
      // Check internet trước
      await CheckInternet.check(
        context,
        showMessage: false,
        onConnected: () async {
          // Check version khi có internet
          await CheckVersion.check(
            context,
            androidPackageId: 'com.example.dat_san_247_mobile',
            iosBundleId: 'com.example.dat_san_247_mobile',
          );

          final firstRun = await AppPreferences.isFirstRun();
          // final firstRun = true;
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
        },
      );
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
