import 'package:dat_san_247_mobile/core/common/function/is_first_run.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dat_san_247_mobile/core/common/db_keys_local.dart';
import 'package:dat_san_247_mobile/core/common/function/share_pref.dart';
import 'package:dat_san_247_mobile/features/bottomMenu/screens/bottom_menu_custom.dart';
import 'package:dat_san_247_mobile/features/intro/presentation/pages/welcome_page.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: 500), () async {
      final isFirstRun =
          await SharedPrefs.getBool(DbKeysLocal.isFirstRun) ?? true;
      final isLogin = await SharedPrefs.getBool(DbKeysLocal.isLogin) ?? false;

      print("isFirstRun: $isFirstRun");
      print("isLogin: $isLogin");

      if (!isFirstRun) {
        Get.offAll(() => WelcomePage());
      } else {
        if (isLogin) {
          Get.offAll(() => BottomMenuCustom());
        } else {
          Get.offAll(() => LoginPage());
        }
      }
    });

    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
