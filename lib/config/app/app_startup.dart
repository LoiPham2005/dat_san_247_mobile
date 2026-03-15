// ════════════════════════════════════════════════════════════════
// 📁 lib/config/app_startup.dart
// ════════════════════════════════════════════════════════════════
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/core/common/utils/logger.dart';
import 'package:dat_san_247_mobile/core/data/network/network_info.dart';
import 'package:dat_san_247_mobile/core/data/storage/local/local_storage_service.dart';
import 'package:dat_san_247_mobile/core/services/app_version/app_version_service.dart';
import 'package:dat_san_247_mobile/core/services/network/network_monitor.dart';
import 'package:dat_san_247_mobile/routes/constants/route_names.dart';
import 'package:go_router/go_router.dart';

import '../../core/base/di/injection.dart';

/// AppStartup: xử lý logic sau khi AppInitializer xong
/// Chạy từ SplashScreen sau khi widget tree đã sẵn sàng
class AppStartup {
  static Future<void> launch(BuildContext context) async {
    try {
      final networkInfo = getIt<NetworkInfo>();
      final hasInternet = await networkInfo.isConnected;

      if (!hasInternet) {
        Logger.warning('Không có kết nối internet. Đang chờ kết nối lại...', tag: 'STARTUP');

        // Dùng Completer để THỰC SỰ chờ cho đến khi có kết nối
        // (startMonitoring chỉ setup listener, không block — cần wrap bằng Completer)
        final completer = Completer<void>();

        await NetworkMonitor().startMonitoring(
          showBanner: true,
          onConnected: () async {
            if (!completer.isCompleted) {
              Logger.info('Đã có kết nối internet. Tiếp tục...', tag: 'STARTUP');
              completer.complete();
              NetworkMonitor().stopMonitoring(); // Dừng monitor sau khi connected
            }
          },
        );

        // Chờ thực sự cho đến khi có kết nối
        await completer.future;
      }

      if (context.mounted) await _continue(context);
    } catch (e, s) {
      Logger.error('Lỗi startup', error: e, stackTrace: s, tag: 'STARTUP');
      // Tiếp tục dù không có mạng — offline navigation sẽ do RouteGuard handle
      if (context.mounted) await _continue(context);
    }
  }

  static Future<void> _continue(BuildContext context) async {
    final storageService = getIt<LocalStorageService>();
    final appVersionService = getIt<AppVersionService>();

    // Kiểm tra cập nhật version (non-blocking nếu không có mạng)
    await appVersionService.checkForUpdate(context);

    // Kiểm tra firstRun
    final firstRun = storageService.isFirstRun();
    if (firstRun) await storageService.setFirstRun(false);

    // Điều hướng
    if (!context.mounted) return;

    if (firstRun) {
      context.go(RouteNames.welcome);
    } else {
      // RouteGuard tự handle redirect về login nếu chưa đăng nhập
      context.go(RouteNames.main);
    }
  }
}
