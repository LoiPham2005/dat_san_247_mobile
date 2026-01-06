// ════════════════════════════════════════════════════════════════
// 📁 lib/core/cache/app_cache_manager.dart
// ════════════════════════════════════════════════════════════════
import 'dart:io';

import 'package:dat_san_247_mobile/core/cache/cache_config.dart';
import 'package:dat_san_247_mobile/core/cache/models/cache_stats.dart';
import 'package:dat_san_247_mobile/core/utils/logger.dart'; // Thêm import Logger
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

/// 🎯 Unified Cache Manager
/// Manages both API cache (Hive) and file cache (flutter_cache_manager)
@lazySingleton
class AppCacheManager {
  // ═══════════════════════════════════════════════════════════════
  // Cache keys (constants)
  // ═══════════════════════════════════════════════════════════════
  static const String _imageCacheKey = 'imageCache';
  static const String _videoCacheKey = 'videoCache';
  static const String _docCacheKey = 'docCache';

  // ═══════════════════════════════════════════════════════════════
  // Stores
  // ═══════════════════════════════════════════════════════════════

  late final CacheStore _apiCacheStore;
  late final CacheManager _imageCacheManager;
  late final CacheManager _videoCacheManager;
  late final CacheManager _documentCacheManager;

  // ═══════════════════════════════════════════════════════════════
  // Stats
  // ═══════════════════════════════════════════════════════════════

  int _hits = 0;
  int _misses = 0;
  DateTime? _lastCleared;

  int get hits => _hits;
  int get misses => _misses;
  double get hitRate => (_hits + _misses == 0) ? 0 : _hits / (_hits + _misses);

  // ═══════════════════════════════════════════════════════════════
  // Initialization
  // ═══════════════════════════════════════════════════════════════

  /// Initialize all caches (call once at app startup)
  Future<void> initialize() async {
    try {
      final sw = Stopwatch()..start();

      // 1. Initialize API cache (Hive)
      await _initApiCache();

      // 2. Initialize file caches
      _initFileCaches();

      sw.stop();
      Logger.success('✅ Cache initialized in ${sw.elapsedMilliseconds}ms');
    } catch (e, stack) {
      Logger.error('❌ Cache init failed', error: e, stackTrace: stack);
      rethrow;
    }
  }

  /// Initialize API cache with Hive backend
  Future<void> _initApiCache() async {
    try {
      // Init Hive if needed
      if (!Hive.isAdapterRegistered(0)) {
        await Hive.initFlutter();
      }

      // Create Hive store
      final cacheDir = await getTemporaryDirectory();
      _apiCacheStore = HiveCacheStore(cacheDir.path);

      // Register with CacheConfig
      CacheConfig.initialize(_apiCacheStore);

      Logger.success('✅ API cache (Hive) ready');
    } catch (e) {
      Logger.warning('⚠️ Hive failed, using MemCache: $e');
      _apiCacheStore = MemCacheStore();
      CacheConfig.initialize(_apiCacheStore);
    }
  }

  /// Initialize file caches (images, videos, documents)
  void _initFileCaches() {
    _imageCacheManager = CacheManager(
      Config(_imageCacheKey, stalePeriod: const Duration(days: 30), maxNrOfCacheObjects: 500),
    );

    _videoCacheManager = CacheManager(
      Config(_videoCacheKey, stalePeriod: const Duration(days: 60), maxNrOfCacheObjects: 100),
    );

    _documentCacheManager = CacheManager(
      Config(_docCacheKey, stalePeriod: const Duration(days: 90), maxNrOfCacheObjects: 100),
    );

    Logger.success('✅ File caches ready');
  }

  // ═══════════════════════════════════════════════════════════════
  // Public Getters
  // ═══════════════════════════════════════════════════════════════

  CacheManager get imageCache => _imageCacheManager;
  CacheManager get videoCache => _videoCacheManager;
  CacheManager get documentCache => _documentCacheManager;

  // ═══════════════════════════════════════════════════════════════
  // Cache Operations
  // ═══════════════════════════════════════════════════════════════

  void recordHit() => _hits++;
  void recordMiss() => _misses++;
  void resetStats() {
    _hits = 0;
    _misses = 0;
  }

  // ═══════════════════════════════════════════════════════════════
  // Clear Operations
  // ═══════════════════════════════════════════════════════════════

  /// Clear API cache only
  Future<void> clearApiCache() async {
    try {
      await _apiCacheStore.clean();
      _lastCleared = DateTime.now();
      Logger.success('✅ API cache cleared');
    } catch (e) {
      Logger.error('❌ Clear API cache failed: $e');
    }
  }

  /// Clear all file caches
  Future<void> clearFileCaches() async {
    try {
      await Future.wait([
        _imageCacheManager.emptyCache(),
        _videoCacheManager.emptyCache(),
        _documentCacheManager.emptyCache(),
      ]);
      Logger.success('✅ File caches cleared');
    } catch (e) {
      Logger.error('❌ Clear file caches failed: $e');
    }
  }

  /// Clear everything
  Future<void> clearAll() async {
    await clearApiCache();
    await clearFileCaches();
    resetStats();
    Logger.success('✅ All caches cleared');
  }

  /// Smart clear - Remove old entries only
  Future<void> clearStale({Duration maxAge = const Duration(days: 7)}) async {
    try {
      if (_lastCleared == null || DateTime.now().difference(_lastCleared!) > maxAge) {
        await clearApiCache();
      }
      Logger.success('✅ Stale cache cleared');
    } catch (e) {
      Logger.error('❌ Clear stale failed: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // Statistics - FIXED ✅
  // ═══════════════════════════════════════════════════════════════

  /// Get cache statistics
  Future<CacheStats> getStats() async {
    try {
      final imageCount = await _countCacheFilesByKey(_imageCacheKey);
      final videoCount = await _countCacheFilesByKey(_videoCacheKey);
      final docCount = await _countCacheFilesByKey(_docCacheKey);

      return CacheStats(
        imageCount: imageCount,
        videoCount: videoCount,
        docCount: docCount,
        totalCount: imageCount + videoCount + docCount,
        hits: _hits,
        misses: _misses,
        hitRate: hitRate,
        lastCleared: _lastCleared,
      );
    } catch (e) {
      Logger.error('❌ Get stats failed: $e');
      return CacheStats.empty();
    }
  }

  /// Count cache files by key
  Future<int> _countCacheFilesByKey(String cacheKey) async {
    try {
      final baseCacheDir = await getTemporaryDirectory();
      final cacheDir = Directory('${baseCacheDir.path}/flutter_cache_manager/$cacheKey');

      if (await cacheDir.exists()) {
        final files = await cacheDir
            .list(recursive: true)
            .where((entity) => entity is File)
            .toList();
        return files.length;
      }

      return 0;
    } catch (e) {
      Logger.warning('⚠️ Error counting cache files for $cacheKey: $e');
      return 0;
    }
  }

  /// Print statistics to console
  // Future<void> printStats() async {
  //   final stats = await getStats();
  //   Logger.info('');
  //   Logger.info('📊 ═══════════════════════════════════════════════════════');
  //   Logger.info('📊 CACHE STATISTICS');
  //   Logger.info('📊 ═══════════════════════════════════════════════════════');
  //   Logger.info('  📷 Images:    ${stats.imageCount} files');
  //   Logger.info('  🎬 Videos:    ${stats.videoCount} files');
  //   Logger.info('  📄 Documents: ${stats.docCount} files');
  //   Logger.info('  ─────────────────────────────────');
  //   Logger.info('  📊 Total:     ${stats.totalCount} files');
  //   Logger.info('  🎯 Hit Rate:  ${(stats.hitRate * 100).toStringAsFixed(1)}%');
  //   Logger.info('  💾 Hits:      ${stats.hits}');
  //   Logger.info('  ❌ Misses:    ${stats.misses}');
  //   if (stats.lastCleared != null) {
  //     Logger.info('  🕐 Last cleared: ${stats.lastCleared}');
  //   }
  //   Logger.info('📊 ═══════════════════════════════════════════════════════');
  //   Logger.info('');
  // }

  Future<void> printStats() async {
    final stats = await getStats();
    const borderWidth = 50;
    String pad(String text) => text.padRight(borderWidth - 2);

    final info = [
      '📊 CACHE STATISTICS',
      'Images:    ${stats.imageCount} files',
      'Videos:    ${stats.videoCount} files',
      'Documents: ${stats.docCount} files',
      '────────────────────────────────',
      'Total:     ${stats.totalCount} files',
      'Hit Rate:  ${(stats.hitRate * 100).toStringAsFixed(1)}%',
      'Hits:      ${stats.hits}',
      'Misses:    ${stats.misses}',
      if (stats.lastCleared != null) 'Last cleared: ${stats.lastCleared}',
    ];

    final buffer = StringBuffer()..writeln('╔${'═' * (borderWidth - 1)}');
    for (final line in info) {
      buffer.writeln('║ ${pad(line)}');
      if (line.startsWith('📊')) {
        buffer.writeln('╠${'═' * (borderWidth - 1)}');
      }
    }
    buffer.writeln('╚${'═' * (borderWidth - 1)}');

    Logger.info('\n${buffer.toString()}', tag: 'CACHE');
  }
}
