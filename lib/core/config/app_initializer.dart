// ════════════════════════════════════════════════════════════════
// 📁 lib/core/config/app_initializer.dart (TỐI ƯU LOGGER)
// ════════════════════════════════════════════════════════════════
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dat_san_247_mobile/core/cache/app_cache_manager.dart';
import 'package:dat_san_247_mobile/core/cache/cache_config.dart';
import 'package:dat_san_247_mobile/core/config/app_bloc_observer.dart';
import 'package:dat_san_247_mobile/core/config/app_observer.dart';
import 'package:dat_san_247_mobile/core/config/environment_config.dart';
import 'package:dat_san_247_mobile/core/di/injection.dart';
import 'package:dat_san_247_mobile/core/l10n/localization_service.dart';
import 'package:dat_san_247_mobile/core/theme/theme_cubit.dart';
import 'package:dat_san_247_mobile/core/utils/logger.dart';
import 'package:dat_san_247_mobile/core/utils/logger_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

      // Phase 1: Config & Setup
      EnvironmentConfig.printInfo();
      LoggerConfig.configure();
      await _configureUI();
      AppObserver().initialize();
      _configureBlocObserver();

      // Phase 2: Cache & Storage
      await _configureHiveAndCache();

      // Phase 3: DI
      await configureDependencies();

      // Phase 4: Managers & Services
      await _initializeCacheManager(); // ✅ NEW!
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
      Logger.warning('Cleaned up after init failure', tag: 'INIT');
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
      Logger.warning('UI config warning: $e', tag: 'INIT');
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
      Logger.success('Services initialized', tag: 'INIT');
    } catch (e, stackTrace) {
      Logger.error('Failed to init services', error: e, stackTrace: stackTrace, tag: 'INIT');
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
      final cacheStore = HiveCacheStore(cacheDir.path, hiveBoxName: 'dio_cache');

      // Initialize cache config
      CacheConfig.initialize(cacheStore);

      Logger.success('Hive & CacheConfig initialized', tag: 'INIT');
    } catch (e, stackTrace) {
      Logger.error('Failed to init Hive & Cache', error: e, stackTrace: stackTrace, tag: 'INIT');
      rethrow;
    }
  }

  /// ✅ NEW: Initialize file caches
  static Future<void> _initializeCacheManager() async {
    try {
      final cacheManager = getIt<AppCacheManager>();
      await cacheManager.initialize();
      Logger.success('AppCacheManager initialized', tag: 'INIT');
    } catch (e, stackTrace) {
      Logger.error('Failed to init AppCacheManager', error: e, stackTrace: stackTrace, tag: 'INIT');
      rethrow;
    }
  }
}
