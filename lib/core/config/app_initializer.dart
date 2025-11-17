// ════════════════════════════════════════════════════════════════
// 📁 lib/core/config/app_initializer.dart (TỐI ƯU LOGGER)
// ════════════════════════════════════════════════════════════════
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base_template/core/config/app_bloc_observer.dart';
import 'package:flutter_base_template/core/config/app_observer.dart';
import 'package:flutter_base_template/core/config/environment_config.dart';
import 'package:flutter_base_template/core/di/injection.dart';
import 'package:flutter_base_template/core/l10n/localization_service.dart';
import 'package:flutter_base_template/core/network/cache/cache_config.dart';
import 'package:flutter_base_template/core/theme/theme_cubit.dart';
import 'package:flutter_base_template/core/utils/logger.dart';
import 'package:flutter_base_template/core/utils/logger_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';

/// 🎯 Quản lý toàn bộ quá trình khởi tạo app
class AppInitializer {
  AppInitializer._();

  static bool _isInitialized = false;
  static bool get isInitialized => _isInitialized;

  /// ✅ Entry point: Khởi tạo app
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
            final stopwatch = Stopwatch()..start();

      // 1️⃣ Environment info
      EnvironmentConfig.printInfo();

      // 2️⃣ Logger config
      LoggerConfig.configure();

      // 3️⃣ UI config
      await _configureUI();

      // 4️⃣ Observers
      AppObserver().initialize();
      _configureBlocObserver();

      // 5️⃣ Hive & Cache (BEFORE DI)
      await _configureHiveAndCache();

      // 6️⃣ DI
      await configureDependencies();

      // 7️⃣ Services
      await _initializeServices();

      stopwatch.stop();
      _isInitialized = true;

      Logger.success('App initialized in ${stopwatch.elapsedMilliseconds}ms', tag: 'INIT');
    } catch (e, stackTrace) {
      Logger.error('Failed to initialize app', error: e, stackTrace: stackTrace, tag: 'INIT');
      await _handleInitializationError();
      rethrow;
    }
  }

  /// 🧹 Xử lý cleanup khi initialization fail
  static Future<void> _handleInitializationError() async {
    try {
      AppObserver().dispose();
      await resetDependencies();
      _isInitialized = false;
      Logger.warning('Cleaned up after initialization failure', tag: 'INIT');
    } catch (e) {
      Logger.error('Cleanup error', error: e, tag: 'INIT');
    }
  }

  /// 📱 Cấu hình UI (orientation, status bar)
  static Future<void> _configureUI() async {
    try {
      // Lock orientation to portrait
      await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

      // Configure system UI overlays
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      );
    } catch (e) {
      Logger.warning('UI configuration warning: $e', tag: 'INIT');
    }
  }

  /// 🔍 Setup BLoC observer (chỉ cho Dev/Staging)
  static void _configureBlocObserver() {
    if (EnvironmentConfig.isDev || EnvironmentConfig.isStaging) {
      Bloc.observer = AppBlocObserver();
    }
  }

  /// ⚙️ Khởi tạo services (theme, localization)
  static Future<void> _initializeServices() async {
    try {
      await Future.wait([getIt<ThemeCubit>().initTheme(), getIt<LocaleCubit>().initLocale()]);
    } catch (e, stackTrace) {
      Logger.error('Failed to initialize services', error: e, stackTrace: stackTrace, tag: 'INIT');
      rethrow;
    }
  }

 // ✅ Fixed: Hive & Cache initialization
  static Future<void> _configureHiveAndCache() async {
    try {
      // Init Hive
      await Hive.initFlutter();

      // Get cache directory
      final cacheDir = await getTemporaryDirectory();

      // Create Hive cache store
      final cacheStore = HiveCacheStore(
        cacheDir.path,
        hiveBoxName: 'dio_cache',
      );

      // Initialize cache config
      CacheConfig.initialize(cacheStore);

      Logger.success('Hive & Cache initialized', tag: 'INIT');
    } catch (e, stackTrace) {
      Logger.error(
        'Failed to initialize Hive & Cache',
        error: e,
        stackTrace: stackTrace,
        tag: 'INIT',
      );
      rethrow;
    }
  }
}
