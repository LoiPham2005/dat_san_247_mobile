// ════════════════════════════════════════════════════════════════
// 📁 lib/core/cache/app_cache_manager.dart
// ════════════════════════════════════════════════════════════════
import 'dart:io';

import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:dat_san_247_mobile/core/cache/cache_config.dart';
import 'package:dat_san_247_mobile/core/cache/models/cache_stats.dart';
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
      print('✅ Cache initialized in ${sw.elapsedMilliseconds}ms');
    } catch (e, stack) {
      print('❌ Cache init failed: $e\n$stack');
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

      print('✅ API cache (Hive) ready');
    } catch (e) {
      print('⚠️ Hive failed, using MemCache: $e');
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

    print('✅ File caches ready');
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
      print('✅ API cache cleared');
    } catch (e) {
      print('❌ Clear API cache failed: $e');
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
      print('✅ File caches cleared');
    } catch (e) {
      print('❌ Clear file caches failed: $e');
    }
  }

  /// Clear everything
  Future<void> clearAll() async {
    await clearApiCache();
    await clearFileCaches();
    resetStats();
    print('✅ All caches cleared');
  }

  /// Smart clear - Remove old entries only
  Future<void> clearStale({Duration maxAge = const Duration(days: 7)}) async {
    try {
      if (_lastCleared == null || DateTime.now().difference(_lastCleared!) > maxAge) {
        await clearApiCache();
      }
      print('✅ Stale cache cleared');
    } catch (e) {
      print('❌ Clear stale failed: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // Statistics - FIXED ✅
  // ═══════════════════════════════════════════════════════════════

  /// Get cache statistics
  Future<CacheStats> getStats() async {
    try {
      // ✅ FIX: Count files correctly using cache key constants
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
      print('❌ Get stats failed: $e');
      return CacheStats.empty();
    }
  }

  /// ✅ CORRECT: Count cache files by key
  /// flutter_cache_manager stores files in: temp/flutter_cache_manager/{key}/
  Future<int> _countCacheFilesByKey(String cacheKey) async {
    try {
      final baseCacheDir = await getTemporaryDirectory();
      final cacheDir = Directory('${baseCacheDir.path}/flutter_cache_manager/$cacheKey');

      if (await cacheDir.exists()) {
        // Count all files recursively
        final files = await cacheDir
            .list(recursive: true)
            .where((entity) => entity is File)
            .toList();
        return files.length;
      }

      return 0;
    } catch (e) {
      print('⚠️ Error counting cache files for $cacheKey: $e');
      return 0;
    }
  }

  /// Print statistics to console
  Future<void> printStats() async {
    final stats = await getStats();
    print('');
    print('📊 ═══════════════════════════════════════════════════════');
    print('📊 CACHE STATISTICS');
    print('📊 ═══════════════════════════════════════════════════════');
    print('  📷 Images:    ${stats.imageCount} files');
    print('  🎬 Videos:    ${stats.videoCount} files');
    print('  📄 Documents: ${stats.docCount} files');
    print('  ─────────────────────────────────');
    print('  📊 Total:     ${stats.totalCount} files');
    print('  🎯 Hit Rate:  ${(stats.hitRate * 100).toStringAsFixed(1)}%');
    print('  💾 Hits:      ${stats.hits}');
    print('  ❌ Misses:    ${stats.misses}');
    if (stats.lastCleared != null) {
      print('  🕐 Last cleared: ${stats.lastCleared}');
    }
    print('📊 ═══════════════════════════════════════════════════════');
    print('');
  }
}
