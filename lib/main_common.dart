import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/app.dart';
import 'package:dat_san_247_mobile/config/environment_config.dart';
import 'package:dat_san_247_mobile/core/utils/logger.dart';

import 'config/app_initializer.dart';

void mainCommon(Environment env) {
  // ✅ Đảm bảo Binding được khởi tạo đầu tiên
  WidgetsFlutterBinding.ensureInitialized();

  // Bắt lỗi UI (Flutter Framework)
  FlutterError.onError = (details) {
    Logger.error('Flutter framework error', error: details.exception, stackTrace: details.stack);
  };

  // Bắt lỗi Global Isolate (Platform)
  PlatformDispatcher.instance.onError = (error, stack) {
    Logger.error('Platform error', error: error, stackTrace: stack);
    return true;
  };

  // Bắt lỗi Async (Dart Zone)
  runZonedGuarded(
    () async {
      EnvironmentConfig.setEnvironment(env);

      // Print debug info
      EnvironmentConfig.printInfo();

      await AppInitializer.initialize();

      runApp(const App());
    },
    (error, stack) {
      Logger.error('Uncaught async error', error: error, stackTrace: stack);
    },
  );
}
