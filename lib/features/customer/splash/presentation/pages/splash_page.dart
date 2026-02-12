import 'package:dat_san_247_mobile/config/app_startup.dart';
import 'package:dat_san_247_mobile/core/ads/services/ad_manager.dart';
import 'package:dat_san_247_mobile/core/di/injection.dart';
import 'package:dat_san_247_mobile/core/theme/app_colors.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final _adManager = getIt<AdManager>();

  @override
  void initState() {
    super.initState();
    // 🚀 Start Auth Check early
    getIt<AuthBloc>().add(const CheckAuthStatusEvent());
    _showSplashAd();
  }

  Future<void> _boot(BuildContext context) async {
    await AppStartup.launch(context); // 🚀 Logic khởi chạy + điều hướng
  }

  Future<void> _showSplashAd() async {
    await Future.delayed(const Duration(seconds: 2));

    await _adManager.showSplashAppOpen();
  }

  @override
  Widget build(BuildContext context) {
    // Khởi tạo app sau khi build hoàn tất
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _boot(context);
    });

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary, AppColors.primary.withOpacity(0.8), AppColors.primaryDark],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.sports_soccer, size: 80, color: AppColors.primary),
                ),
                const SizedBox(height: 24),
                const Text(
                  'ĐẶT SÂN 247',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Hệ thống đặt sân thể thao hàng đầu',
                  style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.9)),
                ),
              ],
            ),
            const Positioned(
              bottom: 50,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
