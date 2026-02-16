import 'package:dat_san_247_mobile/config/app_startup.dart';
import 'package:dat_san_247_mobile/core/ads/services/ad_manager.dart';
import 'package:dat_san_247_mobile/core/di/injection.dart';
import 'package:dat_san_247_mobile/core/theme/app_colors.dart';
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
    // 🚀 Start Sequence
    WidgetsBinding.instance.addPostFrameCallback((_) => _startAppSequence());
  }

  Future<void> _startAppSequence() async {
    // 1. Trigger Auth Check (background)
    // getIt<AuthBloc>().add(const CheckAuthStatusEvent());

    // 2. Minimum Branding Time (2s)
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // 3. Show Ad Sequence (Open -> Inter -> Full Splash)
    // This MUST finish before we proceed to boot/navigate
    // await _adManager.showSplashSequence(context);

    if (!mounted) return;

    // 4. Finally, Boot & Navigate
    await AppStartup.launch(context);
  }

  @override
  Widget build(BuildContext context) {
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
