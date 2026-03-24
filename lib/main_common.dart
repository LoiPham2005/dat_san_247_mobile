import 'dart:async';
import 'dart:ui';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/app.dart';
import 'package:dat_san_247_mobile/config/app/flavor_config.dart';
import 'package:dat_san_247_mobile/core/common/utils/logger.dart';
import 'package:dat_san_247_mobile/core/services/crashlytics/crashlytics_service.dart';

import 'config/app/app_initializer.dart';

void mainCommon(AppFlavor flavor) {
  // Bắt lỗi Async (Dart Zone)
  runZonedGuarded(
    () async {
      // ✅ Đảm bảo Binding được khởi tạo TRONG Zone này để tránh lỗi "Zone mismatch"
      WidgetsFlutterBinding.ensureInitialized();

      FlavorConfig.setFlavor(flavor);
      await AppInitializer.initialize();

      // ─────────────────────────────────────────────────────────────
      // ✅ BẮT LỖI FLUTTER FRAMEWORK (UI thread errors)
      // Ví dụ: lỗi trong build(), initState(), setState()...
      // Đặt SAU initialize() để Crashlytics đã được khởi tạo
      // ─────────────────────────────────────────────────────────────
      FlutterError.onError = (details) {
        final location = _extractErrorLocation(details);
        Logger.error(
          'Flutter framework error',
          error: details.exception,
          stackTrace: details.stack,
          location: location,
        );
        // recordFlutterFatalError = đánh dấu là Fatal crash
        CrashlyticsService.instance.recordFlutterError(details);
      };

      // ─────────────────────────────────────────────────────────────
      // ✅ BẮT LỖI PLATFORM / NATIVE ISOLATE
      // Ví dụ: lỗi plugin, platform channel errors
      // ─────────────────────────────────────────────────────────────
      PlatformDispatcher.instance.onError = (error, stack) {
        Logger.error('Platform error', error: error, stackTrace: stack);
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };

      runApp(const App());
    },
    // ─────────────────────────────────────────────────────────────
    // ✅ BẮT LỖI ASYNC ZONE (không được catch bởi try-catch thông thường)
    // Ví dụ: Future bị lỗi không await, stream không lắng nghe error
    // ─────────────────────────────────────────────────────────────
    (error, stack) {
      Logger.error('Uncaught async error', error: error, stackTrace: stack);
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    },
  );
}

String? _extractErrorLocation(FlutterErrorDetails details) {
  try {
    final msg = details.toString();
    // 1. Try to extract from summary/context (can be package or file path)
    final match = RegExp(r'(?:package:[a-z0-9_]+/|lib/)([^)\s]+\.dart:\d+:\d+)').firstMatch(msg);
    if (match != null) return 'lib/${match.group(1)}';

    // 2. Fallback to stack trace
    if (details.stack != null) {
      final stack = details.stack.toString();
      for (final line in stack.split('\n')) {
        if (line.contains('package:dat_san_247_mobile') || line.contains('lib/')) {
          final m = RegExp(r'(?:package:[a-z0-9_]+/|lib/)([^)\s]+\.dart:\d+:\d+)').firstMatch(line);
          if (m != null) return 'lib/${m.group(1)}';
        }
      }
    }
  } catch (_) {}
  return null;
}
