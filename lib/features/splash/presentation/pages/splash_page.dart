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
    Future.delayed(Duration(milliseconds: 500), () async {
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
    });

    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
