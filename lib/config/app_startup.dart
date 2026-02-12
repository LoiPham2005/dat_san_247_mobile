// ════════════════════════════════════════════════════════════════
// 📁 lib/core/config/app_startup.dart (FIXED)
// ════════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/core/di/injection.dart';
import 'package:dat_san_247_mobile/core/network/network_info.dart';
import 'package:dat_san_247_mobile/core/services/app_version_service.dart';
import 'package:dat_san_247_mobile/core/services/network_monitor.dart';
import 'package:dat_san_247_mobile/core/storage/local/local_storage_service.dart';
import 'package:dat_san_247_mobile/core/utils/logger.dart';
import 'package:dat_san_247_mobile/routes/route_names.dart';
import 'package:go_router/go_router.dart';

/// AppStartup: xử lý logic sau khi AppInitializer xong
class AppStartup {
  static Future<void> launch(BuildContext context) async {
    try {
      // ✅ Sử dụng NetworkInfo (DI) thay vì NetworkMonitor
      final networkInfo = getIt<NetworkInfo>();
      final hasInternet = await networkInfo.isConnected;

      if (!hasInternet) {
        Logger.warning('Không có kết nối internet. Đang chờ kết nối lại...');

        // ✅ Dùng NetworkMonitor cho UI feedback
        await NetworkMonitor().startMonitoring(
          context,
          showSnackBar: true,
          onConnected: () async {
            Logger.info('Đã có kết nối internet. Tiếp tục khởi tạo ứng dụng...');
            await _continue(context);
          },
        );
      } else {
        await _continue(context);
      }
    } catch (e, s) {
      Logger.error('Lỗi khi khởi tạo ứng dụng: $e', stackTrace: s);
      await _continue(context);
    }
  }

  static Future<void> _continue(BuildContext context) async {
    final storageService = getIt<LocalStorageService>();
    final appVersionService = AppVersionService();

    // 🔹 Kiểm tra cập nhật version
    await appVersionService.checkForUpdate(context);

    // 🔹 Kiểm tra trạng thái người dùng
    final firstRun = storageService.isFirstRun();
    // Bỏ check loggedIn ở đây, để RouteGuard tự handle
    // final loggedIn = storageService.isLoggedIn();

    if (firstRun) await storageService.setFirstRun(false);

    // 🔹 Điều hướng
    if (!context.mounted) return;

    if (firstRun) {
      // ✅ Dùng context.go() thay vì pushReplacement
      context.go(RouteNames.welcome);
    } else {
      // ✅ Chỉ cần go(home), nếu chưa login thì Guard sẽ tự redirect về login
      context.go(RouteNames.home);
    }
  }
}
