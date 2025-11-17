import 'package:flutter/material.dart';
import 'package:flutter_base_template/core/config/app_startup.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

   Future<void> _boot(BuildContext context) async {
    await AppStartup.launch(context); // 🚀 Logic khởi chạy + điều hướng
  }

  @override
  Widget build(BuildContext context) {
    // Khởi tạo app sau khi build hoàn tất
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _boot(context);
    });

    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset(
            //   'assets/image/SprotHub_Logo.png',
            //   width: 120,
            //   height: 120,
            // ),
            // const SizedBox(height: 24),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
